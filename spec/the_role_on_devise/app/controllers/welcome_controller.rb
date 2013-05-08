class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :autologin]

  def index; end
  def profile; end

  def autologin
    user = User.find_by_email params[:email]
    sign_in user if user
    redirect_to request.referrer || root_path
  end

end
