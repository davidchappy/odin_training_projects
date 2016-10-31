class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    session[:user_id] = @user.id
    flash[:success] = "Logged in."
    redirect_to user_path(@user)
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
