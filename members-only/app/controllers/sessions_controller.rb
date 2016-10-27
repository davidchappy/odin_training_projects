class SessionsController < ApplicationController

  def new
    @session = params[:session]
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      @current_user = current_user
      flash[:success] = "Logged In."
      redirect_to root_path
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    log_out(@current_user)
    flash[:success] = "Logged Out."
    redirect_to root_path 
  end

end
