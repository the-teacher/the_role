require "the_role/version"
require "the_role/hash"
require "the_role/engine"
require "the_role/the_class_exists"

module TheRole
  # include TheRole::Requires
  # include TheRole::UserModel
  # include TheRole::RoleModel

  NAME_SYMBOLS = /^[a-zA-Z][a-zA-Z0-9_\-]*[a-zA-Z0-9]$/

  # TheRole.get(@role.the_role)
  def self.get str
    hash = YAML::load(str)
    hash ? hash : Hash.new
  end

  module UserModel
    def self.included(base)
      base.class_eval do
        belongs_to :role
        attr_accessible :role
        # when user changed - @the_role should be reload
        after_save { |user| user.instance_variable_set(:@the_role, nil) }
      end
    end
    
    def the_role
      @the_role ||= self.role ? TheRole.get(self.role.the_role) : Hash.new
    end

    def admin?
      role = self.the_role[:system] ? self.the_role[:system][:administrator] : false
      role && role.is_a?(TrueClass)
    end
    
    def moderator? section
      role = self.the_role[:system] ? self.the_role[:moderator][section.to_sym] : false
      role && role.is_a?(TrueClass)
    end

    # TRUE if user has role - administartor of system
    # TRUE if user is moderator of this section (controller_name)
    # FALSE when this section (or role) is nil
    # return current value of role (TRUE|FALSE) if it exists
    def has_role?(section, policy)
      return true   if self.admin?
      return true   if self.moderator? section 
      self.the_role[section.to_sym][policy.to_sym].is_a?(TrueClass) if self.the_role[section.to_sym] && self.the_role[section.to_sym][policy.to_sym]
    end

    # FALSE if object is nil
    # If object is a USER - check for youself
    # Check for owner field - :user_id
    # Check for owner _object_ if owner field is not :user_id
    def owner?(obj)
      return false unless obj
      return true if self.admin?
      return true if self.moderator? obj.class.to_s.tableize # moderator? 'pages'
      return self.id == obj.id          if obj.is_a?(User)
      return self.id == obj[:user_id]   if obj[:user_id]
      return self.id == obj[:user][:id] if obj[:user]
      false
    end
  end#UserModel

  module RoleModel
    def self.included(base)
      base.class_eval do
        has_many :users
        validates :name,  :presence => {:message => I18n.translate('the_role.name_presence')}
        validates :title, :presence => {:message => I18n.translate('the_role.title_presence')}
      end
    end
  end#RoleModel

  # for application controller
  # @the_role_object should be defined with before_filter
  # @the_role_object = @page
  module Requires
    private
    
      def the_role_access_denied
        flash[:error] = t('the_role.access_denied')
        redirect_to root_path
      end
      
      # before_filter :role_require
      def the_role_require
        the_role_access_denied unless current_user.has_role?(controller_name, action_name)
      end

      # before_filter :the_role_object
      # define class variable for *the_owner_require* filter with Controller class name
      # @the_role_object = @article
      def the_role_object
        variable_name   = "@" + self.class.to_s.underscore.split('_').first.singularize
        @the_role_object = self.instance_variable_get("@#{variable_name}")
      end

      # before_filter :owner_and_role_require
      def the_owner_require
        the_role_access_denied unless current_user.owner?(@the_role_object)
      end
  end#Requires
end#TheRole