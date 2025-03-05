#  PropertiesController < ApplicationController
class PropertiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_property, only: %i[show edit update destroy]

  def index
    @search = Property.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @properties = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show
    @search = @property.characteristics.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @characteristics = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def new
    @property = Property.new
  end

  def edit; end

  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to properties_url, notice: 'Property was successfully created.' }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to properties_url, notice: 'Property was successfully updated.' }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_destroy = @property.destroy ? true : false
    message = if @check_destroy == true
      flash.now[:success] = t('.success')
    else
      flash.now[:notice] = @property.errors.full_messages.join(' ')
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to properties_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def search
    if params[:title].present?
      @search_results = Property.where('title ILIKE ?', "%#{params[:title]}%").select(:title, :id)
      render json: @search_results, status: :ok
    else
      render json: @search_results, status: :unprocessable_entity
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, characteristics_attributes: %i[id title _destroy])
  end
end
