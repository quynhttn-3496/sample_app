class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @pagy, @feed_items = pagy current_user.feed, limit: Settings.page_10
    end
  end

  def help; end
end
