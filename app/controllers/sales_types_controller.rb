class SalesTypesController < ApplicationController
  before_action :set_sales_type, only: [:show, :edit, :update, :destroy]

  # GET /sales_types
  # GET /sales_types.json
  def index
    @sales_types = SalesType.all
  end

  # GET /sales_types/1
  # GET /sales_types/1.json
  def show
  end

  # GET /sales_types/new
  def new
    @sales_type = SalesType.new
  end

  # GET /sales_types/1/edit
  def edit
  end

  # POST /sales_types
  # POST /sales_types.json
  def create
    @sales_type = SalesType.new(sales_type_params)

    respond_to do |format|
      if @sales_type.save
        format.html { redirect_to @sales_type, notice: 'Sales type was successfully created.' }
        format.json { render :show, status: :created, location: @sales_type }
      else
        format.html { render :new }
        format.json { render json: @sales_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_types/1
  # PATCH/PUT /sales_types/1.json
  def update
    respond_to do |format|
      if @sales_type.update(sales_type_params)
        format.html { redirect_to @sales_type, notice: 'Sales type was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_type }
      else
        format.html { render :edit }
        format.json { render json: @sales_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_types/1
  # DELETE /sales_types/1.json
  def destroy
    @sales_type.destroy
    respond_to do |format|
      format.html { redirect_to sales_types_url, notice: 'Sales type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_type
      @sales_type = SalesType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_type_params
      params.require(:sales_type).permit(:name)
    end
end
