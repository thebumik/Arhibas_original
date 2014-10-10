class ApplicationController < ActionController::Base
  # include and send notifications of error exceptions to emails
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(trincanu@gmail.com oleg@designcom.md)

  # include all helpers, all the time
  helper :all

  helper_method :settings

  # forgery protection
  protect_from_forgery

  # scrub sensitive parameters from your log
  filter_parameter_logging :password

  # before filters
  before_filter :set_active_language

  # show 404 errors
  if Rails.env.production?
    rescue_from ActiveRecord::ActiveRecordError, ActionController::RoutingError, ActionController::UnknownAction, :with => :raise_404
  end

=begin
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
=end

  private
    def raise_404(exception)
      @title = '404 ERROR...'
      render 'common/error_404', :layout => false, :status => 404
    end

    def settings
      return @settings if defined?(@settings)
      @settings = Settings.all.blank? ? Settings.defaults : Settings.all
    end

    def set_active_language
      I18n.locale = params[:locale]
      I18n.default_locale = 'ro'
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = 'You must be logged in to access this page'
        redirect_to admin_login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = 'You must be logged out to access this page'
        redirect_to admin_categories_url
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
end
