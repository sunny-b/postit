class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :admin?, :creator?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def creator?(post)
    post.user_id == current_user.id
  end

  def require_user
    access_denied unless logged_in?
  end

  def require_admin
    access_denied unless logged_in? && admin?
  end

  def access_denied
    flash[:error] = "You can't do that!"
    redirect_to root_path
  end
end
