class PasswordResetsController < ApplicationController
  USER_PARAMS = %i(password password_confirmation).freeze

  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_password.sent_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "reset_password.not_found_email"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "reset_password.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(*USER_PARAMS)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "not_found_user"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "account_active.not_actived"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset_password.exprired_password"
    redirect_to new_password_reset_url
  end
end
