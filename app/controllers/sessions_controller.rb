class SessionsController < ApplicationController
  def new
  end

  def create
    #get user by the given email address
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      #Create an error messages
      #'flash.now' is specifically designed for displaying flash messages on redered pages
      #the contents of flash.now disappear as soon as there is an additional  request
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # allow log out only when a user is logged in
    log_out if logged_in?
    redirect_to root_url
  end
end
