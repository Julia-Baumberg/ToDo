class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_signin
    return if current_user

    session[:intended_url] = request.url
    redirect_to signin_path, alert: 'Please sign in first!'
  end

  def current_user?(user)
    user == current_user
  end

  def require_admin
    return if current_user_admin?

    redirect_to home_path, alert: 'Unauthorized access!'
  end

  def current_user_admin?
    current_user&.admin?
  end

  def signed_in?
    current_user.present?
  end

  helper_method :current_user?
  helper_method :current_user
  helper_method :current_user_admin?
  helper_method :current_user, :signed_in?
end
