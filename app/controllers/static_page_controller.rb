class StaticPageController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page]).per(Settings.items_per_page)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
