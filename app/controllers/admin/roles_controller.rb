class Admin::RolesController < ApplicationController
  include TheRole::Controller
  layout  TheRole.config.layout.to_s

  before_filter :login_required
  before_filter :role_required

  before_filter :role_find,      only: [:edit, :update, :destroy, :change, :role_export]
  before_filter :owner_required, only: [:edit, :update, :destroy, :change]

  def index
    @roles = Role.all.order('created_at ASC')
  end

  def new
    @role = Role.new
  end

  def edit; end

  def role_export
    role_for_export = {
      @role.name => {
        title:       @role.title,
        description: @role.description,
        role_hash:   @role.to_hash
      }
    }

    role_for_export[:export_comment] = "EXPORT Role with name: *#{ @role.name }*"
    send_data role_for_export.to_json, filename: "TheRole_#{ @role.name }.json"
  end

  def export
    roles = Role.all

    role_for_exports  = roles.inject({}) do |hash, role|
      hash[role.name] = {
        title:       role.title,
        description: role.description,
        role_hash:   role.to_hash
      }
      hash
    end

    role_for_exports[:export_comment] = "EXPORT Roles: *#{ roles.map(&:name).join(', ') }*"
    send_data role_for_exports.to_json, filename: "TheRole_#{ roles.map(&:name).join('-') }.json"
  end

  def import
    roles_hash = params[:roles].try(:read)
    roles_hash = begin; JSON.parse roles_hash; rescue; {}; end
    roles_hash.except!('export_comment')

    if roles_hash.keys.empty?
      flash[:error] = t 'the_role.cant_be_imported'
    else
      roles_list = roles_hash.keys.join(', ')
      update_roles(roles_hash)
      flash[:notice] =  t 'the_role.imported_roles', { roles_list: roles_list }
    end

    redirect_to admin_roles_url
  end

  def create
    @role = Role.new role_params

    if @role.save
      flash[:notice] = t 'the_role.role_created'
      redirect_to_edit
    else
      render :action => :new
    end
  end

  def update
    if @role.update_role params[:role][:the_role]
      flash[:notice] = t 'the_role.role_updated'
      redirect_to_edit
    else
      render :action => :edit
    end
  end

  def change
    if @role.update_attributes!(role_params)
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

  def update_roles roles_hash
    roles_hash.except('export_comment').each_pair do |role_name, role_data|
      title     = role_data['title']
      descr     = role_data['description']
      role_hash = role_data['role_hash']

      role = Role.where(name: role_name).first_or_create(title: title, description: descr)
      role.update_role role_hash = role_hash
    end
  end

  def role_params
    params.require(:role).permit(:name, :title, :description, :the_role, :based_on_role)
  end

  def role_find
    @role = Role.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    @owner_check_object = @role
  end

  def redirect_to_edit
    redirect_to edit_admin_role_path @role
  end

end
