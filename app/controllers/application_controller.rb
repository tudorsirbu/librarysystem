class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_admin!
  after_action :update_last_active
  helper_method :user_active?
  helper_method :current_user

  def session_active?
    if !user_active? && !admin_signed_in?
      redirect_to dashboard_index_path
    end
  end

  def current_user
    unless session[:current_user_id].nil?
        User.find(session[:current_user_id])
    end
  end

  def update_last_active
    unless session[:current_user_id].nil?
      session[:last_active] = Time.now
    end
  end

  def login_user(user_id)
    session[:current_user_id] = user_id
    session[:last_active] = Time.now
  end

  def user_active?
    unless session[:current_user_id].nil? && session[:last_active].nil?
      last_active = session[:last_active]

      if last_active.kind_of?(String)
        last_active = Time.parse(last_active)
      end

      if Time.now - last_active > 60
        session[:current_user_id] = nil
        session[:last_active] = nil
        return false
      else
        return true
      end
    end
  end
end
