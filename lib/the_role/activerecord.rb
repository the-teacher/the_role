module TheRole
  module ActiveRecord
    def has_role
      include TheRole::User
    end

    def acts_as_role
      include TheRole::Role
    end
  end
end