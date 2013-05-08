class PagesController < ApplicationController
  # Devise2 and TheRole before_filters
  before_filter :login_required, :except => [:index, :show]
  before_filter :role_required,  :except => [:index, :show]

  before_filter :find_page,      :only   => [:edit, :update, :destroy]
  before_filter :owner_required, :only   => [:edit, :update, :destroy]

  # Public

  def index
    @pages = Page.wuth_state(:published).all
  end

  def show
    @page = Page.wuth_state(:published).find params[:id]
  end

  # Login && role

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to @page, :notice => 'Page was successfully created.'
    else
      render :action => 'new'
    end
  end

  def my
    @pages = current_user.pages
  end

  # login && role && ownership

  def edit; end

  def update
    if @page.update_attributes(params[:page])
      redirect_to @page, :notice => 'Page was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url
  end

  # Admin or Pages Moderator Role require

  def manage
    @pages = Page.all
  end

  private

  def find_page
    @page = Page.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    @owner_check_object = @page
  end
end