module TheRole
  module Controller
    def login_required
      send TheRole.config.login_required_method
    end

    def role_access_denied
      send TheRole.config.access_denied_method
    end

    private

    def role_required
      role_access_denied unless current_user.has_role?(controller_path, action_name)
    end

    def owner_required
      # TheRole: You should define OWNER CHECK OBJECT
      # When editable object was found
      role_access_denied unless current_user.owner?(@owner_check_object)
    end
  end
end