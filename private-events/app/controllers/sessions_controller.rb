class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user
      session[:user_id] = @user.id
      flash[:success] = "Logged in."
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "Couldn't find a user with that email."
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
