class StaticPagesController < ApplicationController
  def home
  	# if signed_in?
  	# 	@entries = current_user.entries.paginate(page: params[:page])
  	# 	# @feed_items = current_user.feed.paginate(page: params[:page])
   #  else
      @entries = Entry.paginate(page: params[:page])      
  	# end
  end

  def help
  end

  def about
  end

  def contact
  end
end
