module TheRole
  module ActiveRecord
    def has_roles
      include TheRole::User
    end

    def acts_as_role
      include TheRole::Role
    end
  end
end