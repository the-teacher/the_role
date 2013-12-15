module TheRoleController
  private

  def login_required
    authenticate_user! if respond_to?(:authenticate_user!)
    require_login if respond_to?(:require_login)
  end

  def role_access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_back_or_to root_path
  end

  def role_required
    role_access_denied unless current_user.has_role?(controller_path, action_name)
  end

  def owner_required
    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    role_access_denied unless current_user.owner?(@owner_check_object)
  end
end
