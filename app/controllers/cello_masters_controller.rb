class CelloMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cello_master, only: [:show, :edit, :update, :destroy]
  require 'csv'

  # GET /cello_masters
  # GET /cello_masters.json
  def index
    @cello_masters = CelloMaster.all
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
      cello_master = CelloMaster.new
      cello_master.company_name = row['company_name']
      cello_master.divison = row['divison']
      cello_master.category = row['category']
      cello_master.product_name = row['product_name']
      cello_master.capacity = row['capacity']
      cello_master.volume = row['volume']
      cello_master.mrp = row['mrp']
      cello_master.drp = row['drp']
      cello_master.trade_discount = row['trade_discount']
      cello_master.rate = row['rate']
      cello_master.scheme = row['scheme']
      cello_master.net_rate = row['net_rate']
      cello_master.product_image.attach(io: File.open(row['product_image']), filename: 'test.jpeg')
      if cello_master.save
        @cello_masters.push(cello_master)
      end
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
      params.require(:cello_master).permit(:company_name, :divison, :category, :product_name, :capacity, :volume, :mrp, :drp, :trade_discount, :rate, :scheme, :net_rate, :product_image)
    end
end
