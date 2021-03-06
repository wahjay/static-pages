class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
      #UserMailer.account_activation(self).deliver_now
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

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    #using strong parameters to specify what attributes of the user we want to permit
    #it will raise an error if the :user attribute is missing
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
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
