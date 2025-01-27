# TemplsController < ApplicationController
class TemplsController < ApplicationController
  load_and_authorize_resource
  before_action :set_templ, only: %i[show edit update destroy]

  def index
    @search = Templ.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @templs = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    @templ = Templ.new
  end

  def edit; end

  def create
    @templ = Templ.new(templ_params)

    respond_to do |format|
      if @templ.save
        format.html { redirect_to templs_url, notice: t('.success') }
        format.json { render :show, status: :created, location: @templ }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @templ.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @templ.update(templ_params)
        format.html { redirect_to templs_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @templ }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @templ.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @templ.destroy

    respond_to do |format|
      format.html { redirect_to templs_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_templ
    @templ = Templ.find(params[:id])
  end

  def templ_params
    params.require(:templ).permit(:title, :subject, :receiver, :content, :tip, :modelname, :receiver_value, :print_template_id)
  end
end
