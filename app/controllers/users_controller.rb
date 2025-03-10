# UsersController
class UsersController < ApplicationController
  authorize_resource
  before_action :set_user, only: %i[show edit update read_notification delete_notification destroy]

  def index
    @search = User.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @users = @search.result.paginate(page: params[:page], per_page: 50)
  end

  def new
    @user = User.new
    Permission.all_models.size.times do |index|
      @user.permissions.build(
        pmodel: Permission.all_models[index],
        pactions: ['']
      )
    end
  end

  def edit
    @user = User.find(params[:id])
    # we not use this from 20/01/2025
    # if !@user.permissions.present?
    #   Permission.all_models.size.times do |index|
    #     @user.permissions.build(
    #       pmodel: Permission.all_models[index],
    #       pactions: ['']
    #     )
    #   end
    # end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: t('success') }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
    respond_to do |format|
      if @user.update(user_params)
        if params[:user][:role] == 'admin'
          Permission.where(user_id: @user.id).delete_all
        end
        format.html { redirect_to users_url, notice: t('success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if (User.count > 1) && !@user.admin?
      @user.destroy!

      respond_to do |format|
        format.html { redirect_to users_url, notice: t('success') }
        format.json { head :no_content }
      end
    else
      redirect_to users_url, notice: 'Нельзя удалить последнего пользователя или админа'
    end
  end

  def delete_image
    ActiveStorage::Attachment.where(id: params[:image_id])[0].purge
    respond_to do |format|
      # format.html { redirect_to edit_product_path(params[:id]), notice: 'Image was successfully deleted.' }
      format.json { render json: {status: 'ok', message: 'destroyed'} }
    end
  end

  #  для devise чтобы создавать пользователя внутри сервиса

  def admin_new
    @user = User.new
    # Permission.all_models.size.times do |index|
    #   @user.permissions.build(
    #     pmodel: Permission.all_models[index],
    #     pactions: ['']
    #   )
    # end
  end

  def admin_create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: t('success') }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :admin_new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_update
    if params[:user][:role] == 'admin'
      Permission.where(user_id: @user.id).delete_all
    end
    @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: t('success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def read_notification
    @notification = @user.notifications.find_by_id(params[:notification_id])
    @notification.mark_as_read
    respond_to do |format|
      format.turbo_stream{ flash.now[:success] = t('notification.success.read') }
    end
  end

  def delete_notification
    @notification = @user.notifications.find_by_id(params[:notification_id])
    @notification.blob.purge unless @notification.blob.nil?

    @notification.delete
    respond_to do |format|
      format.turbo_stream{ flash.now[:success] = t('notification.success.delete') }
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :phone, :email, :role, :avatar, :password, :password_confirmation, :telegram, :notified,
      permissions_attributes: [:id, :pmodel, :user_id, pactions: []])
  end

end
