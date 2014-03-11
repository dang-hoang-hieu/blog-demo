class EntriesController < ApplicationController
	before_action :signed_in_user, only: [ :edit, :update, :destroy] 
	before_action :correct_user, only: [:edit, :update, :destroy]

	def new
		@entry = current_user.entries.build
	end

	def show
		@entry = Entry.find(params[:id])
		@comments = @entry.comments.paginate(page: params[:page])
	end

	def edit
		@entry ||= Entry.find(params[:id])
	end

	def update
		if @entry.update_attributes(entries_params)
	      flash[:success] = "Entry Updated"
	      redirect_to @entry
	    else
	      render 'edit'
	    end
	end

	def create
		@entry = current_user.entries.build(entries_params)

		if @entry.save
			flash[:success] = "You've just created an entry"
			redirect_to root_url
		else
			flash[:error] = "errors in comment"
			redirect_to root_url
		end
	end

	def destroy
		@entry.destroy
		respond_to do |format|
			format.html { redirect_to root_url }	
			format.js
		end
		
	end

	private
		def entries_params
	  		params.require(:entry).permit(:body, :title)
	  	end

	  	def correct_user
	  		@entry = current_user.entries.find_by(id: params[:id])
	  		redirect_to root_url if @entry.nil?
	  	end 
end
