class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?, :author

  def current_user
    if session[:user_id]
      current_user ||= User.find(session[:user_id])
    elsif cookies.signed[:remember_token]
      hash = Digest::SHA1.hexdigest(cookies.signed[:remember_token].to_s)
      current_user ||= User.find_by(hash)
    else
      return nil
    end
  end

  def current_user=(user)
    current_user = user
  end

  def log_in(user)
    session[:user_id] = user.id
    user.remember
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def log_out(user)
    @current_user = nil
    session.clear
    cookies.delete(:remember_token)
  end

  def logged_in?
    session[:user_id] != nil
  end

  def is_member?
    current_user.member
  end

  def author(post)
    User.find(post.user_id).name
  end

end
