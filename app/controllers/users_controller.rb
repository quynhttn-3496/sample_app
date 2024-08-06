class UsersController < ApplicationController
  before_action :load_user, only: %i(edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.order :name
    @pagy, @users = pagy @users, items: Settings.user_per_page
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "not_found_user"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "account_active.check_mail"
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "edit.success_update"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete.success_deleted_user"
    else
      flash[:danger] = t "delete.fail_deleted_user"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::ATTRIBUTE_PERMITTED
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found_user"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "need_login"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:error] = t "edit.cannot_edit_other_account"
    redirect_to root_url
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
