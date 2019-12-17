class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    #we initially use @user = User.new(params[:user])
    #params[:user] returns a hash of user info
    #Note: this line is dangerous, because by passing in the entire params
    #hash to User.new, we would allow any user of the site to gain administrative access
    #by including admin='1' in the web request

    #we could resolve this by using strong parameters
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      #if fails, render the sign up form again
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    #using strong parameters to specify what attributes of the user we want to permit
    #it will raise an error if the :user attribute is missing
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        #store the page the user wants to go to
        #just so when they log in, we could redirect them to there
        store_location
        redirect_to login_url
      end
    end

    # Confirms the correct user.
   def correct_user
     @user = User.find(params[:id])
     #if current_user does not the profile the current_user wants to change
     #redirect the current_user to the root page
     redirect_to(root_url) unless @user == current_user
   end

   # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
