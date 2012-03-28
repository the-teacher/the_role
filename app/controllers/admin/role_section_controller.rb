class Admin::RoleSectionController < ApplicationController
  include TheRole::Requires

  before_filter :role_login_required
  before_filter :role_require
  before_filter :role_find,           :only => [:destroy, :delete_policy]
  before_filter :owner_require,       :only => [:destroy, :delete_policy]
  
  def destroy
    section_name = params[:id]

    if @role.delete_section section_name
      flash[:notice] = t('the_role.section_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end   
  end

  def delete_rule
    section_name = params[:id]

    if @role.delete_section section_name
      flash[:notice] = t('the_role.section_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def delete_policy
    section_name = params[:id]
    policy_name = params[:name]
    role = TheRole.get(@role.the_role)
    role[section_name.to_sym].delete(policy_name.to_sym)
    
    if @role.update_attributes({:the_role => role.to_yaml})
      flash[:notice] = t('the_role.section_policy_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end#delete_policy

  protected

  def role_find
    @role = Role.find params[:role_id]
    @object_for_ownership_checking = @role
  end
end
