class Admin::RolesController < ApplicationController
  include TheRoleController
  layout TheRole.config.layout.to_s

  before_filter :login_required
  before_filter :role_required

  before_filter :role_find,      only: [:edit, :update, :destroy]
  before_filter :owner_required, only: [:edit, :update, :destroy]

  def index
    @roles = TheRole.role_class.all.order('created_at ASC')
  end

  def new
    @role = TheRole.role_class.new
  end

  def edit; end

  def create
    @role = TheRole.role_class.new role_params

    if @role.save
      flash[:notice] = t 'the_role.role_created'
      redirect_to_edit
    else
      render :action => :new
    end
  end

  def update
    if @role.update_role params[:role][TheRole.role_attribute]
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

  def role_params
    params.require(:role).permit(:name, :title, :description, TheRole.role_attribute)
  end

  def role_find
    @role = TheRole.role_class.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    @owner_check_object = @role
  end

  def redirect_to_edit
    redirect_to edit_admin_role_path @role
  end

end