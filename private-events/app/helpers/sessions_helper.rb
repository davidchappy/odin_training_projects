module SessionsHelper

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def logged_in?
    return true if current_user
    false
  end

  def log_in(user)
    session[:user_id] = user.id if user
  end

end
