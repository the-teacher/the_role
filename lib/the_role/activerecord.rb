module TheRole
  module ActiveRecord
    def has_roles
      include TheRoleUserModel
    end

    def acts_as_role
      include RoleModel
    end
  end
end