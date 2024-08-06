class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try :authenticate, params.dig(:session, :password)
      handle_authenticated_user user
    else
      handle_invalid_user
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def handle_authenticated_user user
    if user.activated?
      reset_session
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      log_in user
      redirect_back_or user
    else
      flash[:warning] = t "account_active.not_actived"
      redirect_to root_url, status: :see_other
    end
  end

  def handle_invalid_user
    flash.now[:danger] = t "invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
