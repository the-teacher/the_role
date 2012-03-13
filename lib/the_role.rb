require "haml"
require "sass"

require "the_role/hash"
require "the_role/engine"
require "the_role/version"
require "the_role/the_class_exists"

module TheRole
  # include TheRole::Requires
  # include TheRole::UserModel
  # include TheRole::RoleModel

  module UserModel
    def self.included(base)
      base.class_eval do
        belongs_to      :role
        attr_accessible :role
        after_save { |user| user.instance_variable_set(:@the_role, nil) }
      end
    end

    # helper
    def param_prepare param
      param.to_s.parameterize.underscore.to_sym
    end
    
    def the_role
      @the_role ||= role.to_hash
    end

    def admin?
      role = the_role[:system] ? the_role[:system][:administrator] : false
      role && role.is_a?(TrueClass)
    end
    
    def moderator? section_name
      return true  if admin?
      section_name = param_prepare(section_name)
      rule = the_role[:moderator] ? the_role[:moderator][section_name] : false
      rule && rule.is_a?(TrueClass)
    end

    # TRUE if user has role - administartor of system
    # TRUE if user is moderator of this section (controller_name)
    # FALSE when this section (or role) is nil
    # return current value of role (TRUE|FALSE) if it exists
    def has_role?(section_name, rule_name)
      return true if admin?
      rule_name    = param_prepare(rule_name)
      section_name = param_prepare(section_name)
      return true if moderator? section_name 
      if the_role[section_name] && the_role[section_name][rule_name]
        the_role[section_name][rule_name].is_a?(TrueClass)
      else
        false
      end
    end

    # FALSE if object is nil
    # If object is a USER - check for youself
    # Check for owner field - :user_id
    # Check for owner _object_ if owner field is not :user_id
    def owner?(obj)
      return false unless obj
      return true if admin?
      return true if moderator? obj.class.to_s.tableize # moderator? 'pages'
      return id == obj.id          if obj.is_a?(User)
      return id == obj[:user_id]   if obj[:user_id]
      return id == obj[:user][:id] if obj[:user]
      false
    end
  end#UserModel

  module RoleModel
    def self.included(base)
      base.class_eval do
        has_many  :users
        validates :name,        :presence => true
        validates :title,       :presence => true
        validates :description, :presence => true
        validates :the_role,    :presence => true

        # helper
        def param_prepare param
          param.to_s.parameterize.underscore.to_sym
        end

        # C
        def create_section section_name
          return false unless section_name.is_a?(String) and !section_name.empty?
          role         = to_hash
          section_name = param_prepare(section_name)
          return false if role[section_name]
          role[section_name] = {}
          update_attributes({:the_role => role.to_yaml})
        end
                
        def create_rule section_name, rule_name
          return false unless create_section(section_name)
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false if role[section_name][rule_name]
          role[section_name][rule_name] = false
          update_attributes({:the_role => role.to_yaml})
        end
        # R
        def to_hash
          begin YAML::load(the_role) rescue {} end
        end

        def to_yaml
          the_role.to_yaml
        end
        # U
        # source_hash will be reset to false
        # except true items from new_role_hash
        # all keys will become symbols
        # look at lib/the_role/hash.rb to find definition of *underscorify_keys* method
        def update_role new_role_hash
          new_role = new_role_hash.underscorify_keys
          role     = to_hash.underscorify_keys.deep_reset
          role.deep_merge! new_role
          update_attributes({:the_role => role.to_yaml})
        end

        def rule_on section_name, rule_name
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          return true  if role[section_name][rule_name] == true
          role[section_name][rule_name] = true
          update_attributes({:the_role => role.to_yaml})
        end

        def rule_off section_name, rule_name
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          return true  if role[section_name][rule_name] == false
          role[section_name][rule_name] = false
          update_attributes({:the_role => role.to_yaml})
        end
        # D
        def delete_section section_name
          return false unless section_name.is_a?(String) and !section_name.empty?
          role         = to_hash
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          role.delete  section_name
          update_attributes({:the_role => role.to_yaml})
        end

        def delete_rule section_name, rule_name
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          role[section_name].delete rule_name
          update_attributes({:the_role => role.to_yaml})
        end
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
        variable_name    = self.class.to_s.tableize.split('_').first.singularize.split('/').last
        @the_role_object = self.instance_variable_get("@#{variable_name}")
      end

      # before_filter :the_owner_require
      def the_owner_require
        the_role_access_denied unless current_user.owner?(@the_role_object)
      end
  end#Requires
end#TheRole