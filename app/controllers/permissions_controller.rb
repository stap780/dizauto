# PermissionsController < ApplicationController
class PermissionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_permission, only: %i[show edit update destroy]
  include ActionView::RecordIdentifier

  def index
    if current_user.admin?
      # @search = Permission.ransack(params[:q])
      # @search.sorts = 'id desc' if @search.sorts.empty?
      # @permissions = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
      @permissions = @user.permissions
    else
      redirect_to root_url, notice: 'You are not admin'
    end
  end

  def show; end

  def new
    # @permission = Permission.new
    @permission = @user.permissions.build
  end

  def edit; end

  def create
    @permission = @user.permissions.build(permission_params)

    respond_to do |format|
      if @permission.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to permission_url(@permission), notice: 'Permission was successfully created.' }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @permission.update(permission_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to permission_url(@permission), notice: 'Permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @permission.destroy

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(dom_id(@user, dom_id(@permission))),
          render_turbo_flash
        ]
      end
      format.html { redirect_to permissions_url, notice: 'Permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_permission
    # @permission = Permission.find(params[:id])
    @permission = @user. permissions.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(:pmodel, :user_id, pactions: [])
  end

end
