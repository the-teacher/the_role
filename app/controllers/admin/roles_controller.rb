class Admin::RolesController < ApplicationController
  include TheRole::Requires
  layout 'the_role'

  before_filter :login_required
  before_filter :role_required

  before_filter :role_find,      :only => [:edit, :update, :destroy]
  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def index
    @roles = Role.all :order => 'created_at ASC'
  end

  def new
    @role = Role.new
  end

  def edit; end

  def create
    @role = Role.new params[:role]

    if @role.save
      flash[:notice] = t 'the_role.role_created'
      redirect_to_edit
    else
      render :action => :new
    end
  end

  def update
    if @role.update_role params[:role].try(:[],:the_role)
      flash[:notice] = t 'the_role.role_updated'
      redirect_to_edit
    else
      render :action => :edit
    end
  end

  def destroy
    @role.destroy
    flash[:notice] = t 'the_role.role_deleted'
    redirect_to admin_roles_url
  end

  protected

  def role_find
    @role = Role.find params[:id]
    @ownership_checking_object = @role
  end

  def redirect_to_edit
    redirect_to edit_admin_role_path @role
  end
  
end