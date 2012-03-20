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
    new_role = params[:role] ? params[:role][:the_role] : Hash.new

    if @role.role_merge! new_role
      flash[:notice] = t('the_role.role_updated')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def new_section
    # validate 1
    if params[:section_name].blank?
      flash[:error] = t('the_role.section_name_is_blank')
      redirect_to edit_admin_role_path(@role) and return
    end

    # validate 2
    section_name = params[:section_name]
    unless section_name.match(TheRole::NAME_SYMBOLS)
      flash[:error] = t('the_role.section_name_is_wrong')
      redirect_to edit_admin_role_path(@role) and return
    end

    section_name.downcase!
    role = TheRole.get(@role.the_role)

    # validate 3
    if role[section_name.to_sym]
      flash[:error] = t('the_role.section_exists')
      redirect_to edit_admin_role_path(@role) and return
    end

    role[section_name.to_sym] = Hash.new
    
    if @role.role_merge! role
      flash[:notice] = t('the_role.section_created')
      redirect_to edit_admin_role_path(@role)
    else
      render :action => :edit
    end
  end
  
  def new_rule
    params[:section_rule].downcase!
    
    # validate 1
    unless params[:section_rule].match(TheRole::NAME_SYMBOLS)
      flash[:error] = t('the_role.section_rule_wrong_name')
      redirect_to edit_admin_role_path(@role)
    end

    role = TheRole.get(@role.the_role)
    role[params[:section_name].to_sym][params[:section_rule].to_sym] = true 

    if @role.update_attributes({:the_role => role.to_yaml})
      flash[:notice] = t('the_role.section_rule_created')
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
