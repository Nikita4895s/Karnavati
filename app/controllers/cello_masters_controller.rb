class CelloMastersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  before_action :set_cello_master, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session
  require 'csv'

  # GET /cello_masters
  # GET /cello_masters.json
  def index
    @q = CelloMaster.ransack(params[:q])
    @cello_masters = @q.result.order('created_at')
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
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'cello_product_pdf',
        background: true
     end
    end
    CelloMaster.update_all(discount: 0.0)
  end

  def update_discount
    cello_master = CelloMaster.find_by(id: params['id'])
    if cello_master.update(discount: params[:discount])
      data = { rate: (cello_master.drp - (cello_master.drp * params[:discount].to_f / 100))}
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
      cello_master = CelloMaster.find_or_initialize_by(
        product_code: row['product_code'])
      cello_master.assign_attributes(
        company_name: row['company_name'],
        divison: row['divison'],
        category: row['category'],
        product_name: row['product_name'],
        capacity: row['capacity'],
        mrp: row['mrp'],
        drp: row['drp'],
        link_url: row['product_name'].include?('https://drive.google.com/open?id=') ?
        row['product_image'] : "https://drive.google.com/open?id=#{row['product_image']}",
        hsn_no: row['hsn_no'],
        product_mode: row['product_mode'],
        discount: row['discount'],
        arrival_date: row['arrival_date'],
        product_code: row['product_code'],
        gst_per: row['gst_per']
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
      if cello_master.save
        @cello_masters.push(cello_master)
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
        :capacity, :mrp, :drp, :link_url, :hsn_no, :product_mode, :discount,
        :arrival_date, :product_code, :gst_per)
    end
end
