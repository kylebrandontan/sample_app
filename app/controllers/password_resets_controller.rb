class PasswordResetsController < ApplicationController
before_action :get_user, only: [:edit, :update]
before_action :valid_user, only: [:edit, :update]
before_action :check_expiration, only: [:edit, :update] #Case 1, expired password reset


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?        #Case 3, empty password
      @user.errors.add(:password, "can't be empty!")
      render 'edit'
    elsif @user.update_attributes(user_params) #Case 4, successful!
      log_in @user
      flash[:success] = "Good job bro. Now don't forget your password again!"
      redirect_to @user
    else
      render 'edit'                             #Case 2, when invalid password attempt
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  #Gets the user
  def get_user
    @user = User.find_by(email: params[:email])
  end

  #Confirms a valid user.
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  #Confirms expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "You have exceeded the time. Go through the process again."
      redirect_to new_password_reset_url
    end
  end
end
