class ApplicationController < ActionController::Base
  include TheRole::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protect_from_forgery
  before_filter :set_locale

  def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
  end

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