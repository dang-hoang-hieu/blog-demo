class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]
  before_action :friends, only: :create

  def create
  	@comment = current_user.comments.build(comments_params)
  	if @comment.save
  		flash.now[:success] = "comment created"  		
  	else
  		flash.now[:error] = "error"  		
  	end
  	respond_to do |format|
  		format.html { redirect_to root_url}
  		format.js
  	end  		  	
  end

  def destroy  	
  	@comment.destroy
	respond_to do |format|
		format.html { redirect_to root_url }	
		format.js
	end
  end  

  private
  	def comments_params
  		params.require(:comment).permit(:content, :entry_id)
  	end

  	def correct_user
  		@comment = current_user.comments.find_by(id: params[:id])
  		redirect_to root_url if @comment.nil?
  	end

  	def friends
  		@entry = Entry.find(comments_params[:entry_id])
  		@friends = @entry.user.followers
  		redirect_to root_url unless @friends.include?(current_user)
  	end  	
end
