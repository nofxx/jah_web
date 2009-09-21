# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_time_zone
  before_filter :set_locale
  filter_parameter_logging :password, :password_confirmation

 private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  alias :cu :current_user

  def require_user
    unless current_user
      store_location
      flash[:notice] = "Entre com sua senha para acessar."
      redirect_to "/login" #new_user_session_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def rescue_access_denied
    flash[:error] = 'Acesso negado!'
    redirect_to "/"
  end

  def set_locale
    locale = current_user.locale if current_user
    I18n.locale = locale || params[:locale] || 'en'
  end

  def set_time_zone
    Time.zone = current_user ? current_user.time_zone : "Brasilia"
  end

end
