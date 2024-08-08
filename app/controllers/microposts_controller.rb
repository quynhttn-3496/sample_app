class MicropostsController < ApplicationController
  MICROPOST_PARAMS = %i(content image).freeze
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "micropost.created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy(current_user.feed, limit: Settings.page_10)
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.deleted_success"
    else
      flash[:danger] = t "micropost.deleted_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(*MICROPOST_PARAMS)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost.invalid"
    redirect_to request.referer || root_url
  end
end
