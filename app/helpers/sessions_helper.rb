module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    #rethrn the current logged-in user (if any)
    if session[:user_id]
      #get current_user if it's nil, else return as it is
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #return true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
