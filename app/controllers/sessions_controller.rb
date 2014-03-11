class SessionsController < ApplicationController
	def new

	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			flash[:success] = "Sign in successfully"
			# redirect_to user
			redirect_back_or(user)
		else
			flash.now[:error] = "email or password is incorrect"
			session.delete(:return_to)
			render 'new'
		end		
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
