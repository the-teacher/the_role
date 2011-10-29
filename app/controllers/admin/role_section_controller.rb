class Admin::RoleSectionController < ApplicationController
  # before_filter :login_required
  before_filter :find_role, :only=>[:destroy, :delete_policy]
  
  def destroy
    section_name = params[:id]
    role = TheRole.get(@role.the_role)
    role.delete(section_name.to_sym)

    if @role.update_attributes({:the_role => role.to_yaml})
      flash[:notice] = t('the_role.section_deleted')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end   
  end#destroy
  
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

  def find_role
    @role = Role.find(params[:role_id])
  end
end
