class ApplicationController < ActionController::Base
  include TheRoleController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protect_from_forgery
  before_filter :set_locale

  def access_denied
    render :text => 'access_denied: requires an role' and return
  end

  alias_method :login_required,     :authenticate_user!
  alias_method :role_access_denied, :access_denied

  private

  def set_locale
    locale = 'en'
    langs  = %w{ en ru es pl zh_CN }

    if params[:locale]
      lang = params[:locale]
      if langs.include? lang
        locale           = lang
        cookies[:locale] = lang
      end
    else
      if cookies[:locale]
        lang   = cookies[:locale]
        locale = lang if langs.include? lang
      end
    end

    I18n.locale = locale
    redirect_to(:back) if params[:locale]
  end
end