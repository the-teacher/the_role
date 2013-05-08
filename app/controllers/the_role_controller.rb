module TheRoleController
  private

  def role_access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to '/'
  end

  def role_required
    role_access_denied unless current_user.has_role?(controller_name, action_name)
  end

  def owner_required
    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    role_access_denied unless current_user.owner?(@owner_check_object)
  end
end
