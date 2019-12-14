class UsersController < ApplicationController
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
      # Handle a successful save.
      #the message displayed after a sucessful signup
      #and will disappear on visiting a second page
      flash[:success] = "Welcome to the Sample App!"
      #equivalent to 'redirect_to user_url(@user)'
      redirect_to @user
    else
      #if fails, render the sign up form again
      render 'new'
    end
  end



  private
    #using strong parameters to specify what attributes of the user we want to permit
    #it will raise an error if the :user attribute is missing
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
