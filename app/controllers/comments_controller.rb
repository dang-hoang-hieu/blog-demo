class CommentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
  	@comment = current_user.comments.build(comments_params)

  	if @comment.save
  		@status = "comment created"  		  		
  	else
  		@status = "error"
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
end
