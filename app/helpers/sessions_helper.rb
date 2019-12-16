module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    #this line creates a random remember_token and digest it and save to the database
    user.remember
    #use cookies to associate the user_id with the digested remember_token
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token

  end

  def current_user
    #rethrn the current logged-in user (if any) (temporary)
    # this if statement means: “If session of user id exists (while setting user id to session of user id)"
    if (user_id = session[:user_id])
      #get current_user if it's nil, else return as it is
      @current_user ||= User.find_by(id: session[:user_id])

    #check cookie (permanent session)
    elsif (user_id = cookies.signed[:user_id])
      #'cookies.signed[:user_id]' automatically decrypt user_id and use it
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  #return true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session
  def forget(user)
    #update the user.remember_digest to nil
    user.forget
    #remove the user_id from the cookies
    cookies.delete(:user_id)
    #remove correspoding remember_token from the cookies
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
