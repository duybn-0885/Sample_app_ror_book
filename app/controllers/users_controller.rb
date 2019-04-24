class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  ORDER_BY_ATTRIBUTE = "created_at"

  def index
    @users = Kaminari.paginate_array(User.all.order ORDER_BY_ATTRIBUTE).page(params[:page])
      .per(Settings.items_per_page)
  end

  def new
    @user = User.new
  end

  def show
    if @user.nil?
      render "layouts/notfound"
    end
  end


  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t("check_email")
      redirect_to root_url
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("success_deleted")
    else
      flash[:danger] = t("failure_deleted")
    end
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t("please_log_in")
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def find_user
      @user = User.find_by(id: params[:id])

      if @user.nil?
        render "layouts/notfound"
      end
    end
end
