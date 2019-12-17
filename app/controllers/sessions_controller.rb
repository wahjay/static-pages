class SessionsController < ApplicationController
  def new
  end

  def create
    #get user by the given email address
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
