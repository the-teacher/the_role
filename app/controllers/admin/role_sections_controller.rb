class Admin::RoleSectionsController < ApplicationController
  include TheRole::Requires
  layout 'the_role'

  before_filter :login_required
  before_filter :role_required

  before_filter :role_find,           :only => [:create, :create_rule, :destroy, :destroy_rule]
  before_filter :owner_required,      :only => [:create, :create_rule, :destroy, :destroy_rule]

  def create
    if @role.create_section params[:section_name]
      flash[:notice] = t('the_role.section_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def create_rule
    if @role.create_rule(params[:section_name], params[:rule_name])
      flash[:notice] = t('the_role.section_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def destroy
    section_name = params[:id]

    if @role.delete_section section_name
      flash[:notice] = t('the_role.section_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end   
  end
  
  def destroy_rule
    section_name = params[:id]
    rule_name    = params[:name]
    if @role.delete_rule(section_name, rule_name)
      flash[:notice] = t('the_role.section_rule_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end

  protected

  def role_find
    @role = Role.find params[:role_id]
    @ownership_checking_object = @role
  end
end