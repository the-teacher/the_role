class Admin::RolesController < ApplicationController
  include TheRole::Requires

  before_filter :role_login_required
  before_filter :role_require
  before_filter :role_find,           :only => [:show, :edit, :update, :destroy, :new_section, :new_rule]
  before_filter :owner_require,       :only => [:show, :edit, :update, :destroy, :new_section, :new_rule]

  def index
    @roles = Role.all(:order => "created_at ASC")
  end

  def new
    @role = Role.new
  end

  def edit; end

  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = t('the_role.role_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :new
    end
  end

  def update
    if @role.update_role params[:role][:the_role]
      flash[:notice] = t('the_role.role_updated')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def new_section
    if @role.create_section params[:section_name]
      flash[:notice] = t('the_role.section_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def new_rule
    if @role.create_rule(params[:section_name], params[:section_rule])
      flash[:notice] = t('the_role.section_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end

  def destroy
    @role.destroy
    redirect_to admin_roles_url
  end

  protected

  def role_find
    @role = Role.find params[:id]
    @object_for_ownership_checking = @role
  end
  
end
