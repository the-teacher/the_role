class Admin::RoleSectionController < ApplicationController
  include TheRole::Requires

  before_filter :role_login_required
  before_filter :role_require
  before_filter :role_find,           :only => [:new, :new_rule, :destroy, :destroy_rule]
  before_filter :owner_require,       :only => [:new, :new_rule, :destroy, :destroy_rule]

  def new
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
    role         = TheRole.get(@role.the_role)
    role[section_name.to_sym].delete(rule_name.to_sym)
    
    if @role.update_attributes({:the_role => role.to_yaml})
      flash[:notice] = t('the_role.section_rule_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end

  protected

  def role_find
    @role = Role.find params[:role_id]
    @object_for_ownership_checking = @role
  end
end
