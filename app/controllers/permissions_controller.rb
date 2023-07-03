class PermissionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_permission, only: %i[ show edit update destroy ]

  # GET /permissions or /permissions.json
  def index
    if current_user.admin?
      @search = Permission.ransack(params[:q])
      @search.sorts = 'id desc' if @search.sorts.empty?
      @permissions = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    else
      redirect_to root_url, notice: "You are not admin" 
    end
  end

  # GET /permissions/1 or /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully created." }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully updated." }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to permissions_url, notice: "Permission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def permission_params
      params.require(:permission).permit(:pmodel, :user_id, pactions: [])
    end
end
