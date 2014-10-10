class AdminController < ApplicationController
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  before_filter :set_active_language, :require_user

  def index
    redirect_to admin_categories_path
  end

  protected
    def set_active_language
      I18n.default_locale = 'en'
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def add_breadcrumb(*args)
      @breadcrumb = Array.new
      args.each do |a|
        if a.is_a?(Array)
          @breadcrumb = @breadcrumb + a
        else
          @breadcrumb << a
        end
      end
    end
end
