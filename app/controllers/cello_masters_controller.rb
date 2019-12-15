class CelloMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cello_master, only: [:show, :edit, :update, :destroy]

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
      params.require(:cello_master).permit(:company_name, :divison, :category, :product_name, :capacity, :volume, :mrp, :drp, :trade_discount, :rate, :scheme, :net_rate)
    end
end
