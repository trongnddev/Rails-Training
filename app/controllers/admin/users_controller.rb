class Admin::UsersController < AdminController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_users
  add_flash_types :success, :warning, :danger, :info

  #authorization with cancancan
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.role = "staff"
    respond_to do |format|
      if @user.save
        format.html { render :index, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { render :index, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    flash[:info] = "User was successfully destroyed!"
    render :index
    
  end

  private
    def set_user
      @user = User.find(params[:id]) 
    end

    def set_users
      @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation
        )
    end
end
