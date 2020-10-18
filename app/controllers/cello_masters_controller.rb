class CelloMastersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  before_action :set_cello_master, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session
  require 'csv'

  # GET /cello_masters
  # GET /cello_masters.json
  def index
    if params[:q].present?
      @q = CelloMaster.ransack(params[:q])
      @cello_masters = @q.result.order('created_at')
    else
      @q = CelloMaster.ransack(params[:q])
      @cello_masters = CelloMaster.all.order('created_at').paginate(page: params[:page], per_page: 15)
    end
  end

  # GET /cello_masters/1
  # GET /cello_masters/1.json
  def show
  end

  # GET /cello_masters/new
  def new
    @cello_master = CelloMaster.new
  end

  # GET /cello_masters/1/edit
  def edit
  end

  def download_pdf
    selected_ids = params[:selected_ids].split(',').map(&:to_i)
    @cello_masters = CelloMaster.where(id: selected_ids)
    @pdf_name = params[:pdf_file_name]
    @start_range = params[:from_rs]
    @end_range = params[:to_rs]
    @remark = params[:remark]
    if params[:send_email].present? && params[:send_email].eql?('true')
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string('cello_masters/generate_pdf.html.erb', layout: nil)
      )
      save_path = Rails.root.join('public',"#{@pdf_name.parameterize.underscore}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      redirect_to new_email_path(url: save_path)
    else
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'cello_product_pdf',
          background: true
       end
      end
      CelloMaster.where('discount != ?',0.0).each {|cm| cm.update(discount: 0.0, rate: cm.drp)}
    end
  end

  def download_image
    @cello_master = CelloMaster.find_by(id: params[:id])
    url = @cello_master.link_url.split('=').last
    # image = MiniMagick::Image.open("http://drive.google.com/uc?export=view&id=#{url}")
    image = MiniMagick::Image.open(Rails.root.join('public/product_images/' + @cello_master.product_image))
    height = image.height
    width = image.width
    if height == width
      @height = 800
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string('cello_masters/generate_image.html.erb', layout: nil)
      )
    elsif height < width
      @height = 600
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string('cello_masters/generate_image.html.erb', layout: nil),
        page_size: 'Letter'
        # page_height: 148, page_width: 210
      )
    else
      @height = 1200
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string('cello_masters/generate_image.html.erb', layout: nil),
        page_size: 'A3'
        # page_height: 148, page_width: 210
      )
    end
    save_path = Rails.root.join('public','filename.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    require 'rmagick'
    new_pdf = Magick::ImageList.new(save_path)
    new_pdf_path = "#{@cello_master.product_name.parameterize.underscore}.jpg"
    new_pdf.write(new_pdf_path)
    send_file(new_pdf_path)
    File.delete(save_path)
  end

  def update_discount
    cello_master = CelloMaster.find_by(id: params['id'])
    rate = (cello_master.drp - (cello_master.drp * params[:discount].to_f / 100))
    if cello_master.update(discount: params[:discount], rate: rate)
      data = { rate: rate}
      render json: data
    end
  end

  def search_data
    @cello_masters = CelloMaster.all
    @divison = @cello_masters.pluck(:divison).uniq
    @category = @cello_masters.pluck(:category).uniq
    @product_name = @cello_masters.pluck(:product_name).uniq
    @capacity = @cello_masters.pluck(:capacity).uniq
    if params[:company_name].present?
      @cello_masters = @cello_masters.where(company_name: params[:company_name])
      @divison = @cello_masters.pluck(:divison).uniq
      @category = @cello_masters.pluck(:category).uniq
      @product_name = @cello_masters.pluck(:product_name).uniq
      @capacity = @cello_masters.pluck(:capacity).uniq
    end
    if params[:divison].present?
      @cello_masters = @cello_masters.where(divison: params[:divison])
      @category = @cello_masters.pluck(:category).uniq
      @product_name = @cello_masters.pluck(:product_name).uniq
      @capacity = @cello_masters.pluck(:capacity).uniq
    end
    if params[:category].present?
      @cello_masters = @cello_masters.where(category: params[:category])
      @product_name = @cello_masters.pluck(:product_name).uniq
      @capacity = @cello_masters.pluck(:capacity).uniq
    end
    if params[:product_name].present?
      @cello_masters = @cello_masters.where(product_name: params[:product_name])
      @capacity = @cello_masters.pluck(:capacity).uniq
    end
    if params[:capacity].present?
      @cello_masters = @cello_masters.where(capacity: params[:capacity])
    end
    # @cello_masters = CelloMaster.all
    # @company_name = params[:company_name] ? params[:company_name] : @cello_masters.pluck(:company_name)
    # @divison = params[:divison] ? params[:divison] : @cello_masters.where(company_name: @company_name).pluck(:divison)
    # @category = params[:category] ? params[:category] : @cello_masters.pluck(:category)
    # @product_name = params[:product_name] ? params[:product_name] : @cello_masters.pluck(:product_name)
    # @capacity = params[:capacity] ? params[:capacity] : @cello_masters.pluck(:capacity)
    # @cello_masters = @cello_masters.where(
    #   'company_name IN (?) and divison IN (?) or category IN (?) or product_name IN (?), capacity IN (?)',
    #   @company_name, @divison, @category, @product_name, @capacity
    # )
  end

  # POST /cello_masters
  # POST /cello_masters.json
  def create
    @cello_master = CelloMaster.new(cello_master_params)
    respond_to do |format|
      if @cello_master.save
        format.html { redirect_to @cello_master, notice: 'Cello master was successfully created.' }
        format.json { render :show, status: :created, location: @cello_master }
      else
        format.html { render :new }
        format.json { render json: @cello_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cello_masters/1
  # PATCH/PUT /cello_masters/1.json
  def update
    respond_to do |format|
      if @cello_master.update(cello_master_params)
        format.html { redirect_to @cello_master, notice: 'Cello master was successfully updated.' }
        format.json { render :show, status: :ok, location: @cello_master }
      else
        format.html { render :edit }
        format.json { render json: @cello_master.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_csv
    csv = File.read(params[:cello_master][:picture])
    @cello_masters = []
    CSV.parse(csv, headers: true).each do |row|
      if row.to_hash.values.compact.present?
        cello_master = CelloMaster.find_or_initialize_by(
          product_code: row['product_code'])
        product_image = row['product_image']&.gsub('https://drive.google.com/file/d/', '')&.gsub('/view?usp=sharing', '')&.gsub('https://drive.google.com/open?id=', '')
        rate = row['drp'].present? && row['discount'].present? ?
                (row['drp'] - (row['drp'] * row['discount'].to_f / 100)) :
                row['drp']
          # link_url: product_image&.include?('https://drive.google.com/open?id=') ?
          # product_image : "https://drive.google.com/open?id=#{product_image}",
        cello_master.assign_attributes(
          company_name: row['company_name']&.upcase&.strip,
          divison: row['divison']&.upcase&.strip,
          category: row['category']&.upcase&.strip,
          product_name: row['product_name']&.upcase&.strip,
          capacity: row['capacity']&.upcase&.strip,
          mrp: row['mrp'],
          drp: row['drp'],
          hsn_no: row['hsn_no'],
          product_mode: row['product_mode']&.upcase&.strip,
          discount: row['discount'],
          link_url: product_image,
          arrival_date: row['arrival_date'],
          product_code: row['product_code']&.upcase&.strip,
          gst_per: row['gst_per'],
          rate: rate
        )
        # if row['product_image'].present?
        #   file_name = row['product_image'].split('/').last
        #   file_type = "image/#{file_name.split('.').last}"
        #   cello_master.product_image.attach(
        #     io: File.open(row['product_image']),
        #     filename: file_name,
        #     content_type: file_type,
        #     identify: false
        #   )
        # end
        if ((cello_master.new_record? || (!cello_master.new_record? && (cello_master.changes.include?('link_url') || cello_master.product_image.nil?)))) && product_image.present?
            drive_link = "https://drive.google.com/uc?export=view&id=#{product_image}"
          begin
            image_file = MiniMagick::Image.open(drive_link)
            image_path = Rails.root.join('public/product_images/' + "#{product_image}.#{image_file&.type&.downcase}")
          rescue Exception => e
            image_path = Rails.root.join('public/product_images/' + "#{product_image}.jpeg")
            @cello_masters.push(row)
          end
            file = File.new(image_path, 'wb')
            download_file = open(drive_link)
            IO.copy_stream(download_file, file)
            cello_master.product_image = "#{product_image}.#{image_file&.type&.downcase || 'jpeg'}"
          # image_link = Cloudinary::Uploader.upload("https://drive.google.com/uc?export=view&id=#{product_image}")
          # cello_master.remote_product_image_url = image_link['url']
        end
        if cello_master.save
          @cello_masters.push(cello_master)
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to cello_masters_url, notice: 'CSV data uploaded successfully.' }
      format.json { head :no_content }
    end
  end

  # DELETE /cello_masters/1
  # DELETE /cello_masters/1.json
  def destroy
    @cello_master.destroy
    respond_to do |format|
      format.html { redirect_to cello_masters_url, notice: 'Cello master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cello_master
      @cello_master = CelloMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cello_master_params
      params.require(:cello_master).permit(:company_name, :divison, :category, :product_name,
        :capacity, :mrp, :drp, :link_url, :hsn_no, :product_mode, :discount, :product_image,
        :arrival_date, :product_code, :gst_per)
    end
end
