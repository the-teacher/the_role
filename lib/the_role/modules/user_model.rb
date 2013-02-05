module TheRole
  module UserModel
    extend ActiveSupport::Concern

    include TheRole::Base
    include TheRole::ParamHelper
    
    included do
      class_eval do
        belongs_to :role
        after_save { |user| user.instance_variable_set(:@role_hash, nil) }
      end
    end

    def role_hash; @role_hash ||= role.to_hash; end

    # FALSE if object is nil
    # If object is a USER - check for youself
    # Check for owner field - :user_id
    # Check for owner _object_ if owner field is not :user_id
    def owner? obj
      return false unless obj
      return true  if admin?

      section_name = obj.class.to_s.tableize
      return true  if moderator?(section_name)

      return id == obj.id          if obj.is_a?(User)
      return id == obj[:user_id]   if obj[:user_id]
      return id == obj[:user][:id] if obj[:user]
      false
    end
  end
end