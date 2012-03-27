require "haml"
require "sass"

require "the_role/hash"
require "the_role/engine"
require "the_role/version"
require "the_role/the_class_exists"

module TheRole
  # include TheRole::Base
  # include TheRole::Requires
  # include TheRole::UserModel
  # include TheRole::RoleModel
  # include TheRole::ParamHelper

  module Base
    def has_role? section_name, rule_name
      hash         =  role_hash
      section_name =  param_prepare(section_name)
      rule_name    =  param_prepare(rule_name)
      return true  if hash[:system]    and hash[:system][:administrator]
      return true  if hash[:moderator] and hash[:moderator][section_name]
      return false unless hash[section_name]
      return false unless hash[section_name].key? rule_name
      hash[section_name][rule_name]
    end

    def moderator? section_name
      section_name = param_prepare(section_name)
      has_role? section_name, :any_crazy_name
    end

    def admin?
      has_role? :any_crazy_name, :any_crazy_name
    end
  end

  module ParamHelper
    def param_prepare param
      param.to_s.parameterize.underscore.to_sym
    end
  end

  module UserModel
    include TheRole::Base
    include TheRole::ParamHelper
    def role_hash; @role_hash ||= role.to_hash; end

    # FALSE if object is nil
    # If object is a USER - check for youself
    # Check for owner field - :user_id
    # Check for owner _object_ if owner field is not :user_id
    def owner? obj
      return false unless obj
      return true  if admin?

      section_name = obj.class.to_s.tableize # => 'pages', 'articles' ect
      return true  if moderator?(section_name)

      return id == obj.id          if obj.is_a?(User)
      return id == obj[:user_id]   if obj[:user_id]
      return id == obj[:user][:id] if obj[:user]
      false
    end

    def self.included(base)
      base.class_eval do
        belongs_to      :role
        attr_accessible :role
        after_save { |user| user.instance_variable_set(:@role_hash, nil) }
      end
    end

  end#UserModel

  module RoleModel
    include TheRole::Base
    include TheRole::ParamHelper

    def role_hash; to_hash; end
    alias_method :has?, :has_role?

    def has_section? section_name
      section_name = param_prepare(section_name)
      to_hash.key? section_name
    end

    def self.included(base)
      base.class_eval do
        has_many  :users
        validates :name,        :presence => true
        validates :title,       :presence => true
        validates :description, :presence => true
        validates :the_role,    :presence => true

        # C
        
        def create_section section_name = nil
          return false unless section_name
          role         =  to_hash
          section_name =  param_prepare(section_name)
          return false if section_name.blank?
          return true  if role[section_name]
          role[section_name] = {}
          update_attributes(:the_role => role.to_yaml)
        end
                
        def create_rule section_name, rule_name
          return false unless create_section(section_name)
          role         =  to_hash
          rule_name    =  param_prepare(rule_name)
          section_name =  param_prepare(section_name)
          return true  if role[section_name][rule_name]
          role[section_name][rule_name] = false
          update_attributes(:the_role => role.to_yaml)
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
          update_attributes(:the_role => role.to_yaml)
        end

        def rule_on section_name, rule_name
          role         =  to_hash
          rule_name    =  param_prepare(rule_name)
          section_name =  param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          return true  if     role[section_name][rule_name]
          role[section_name][rule_name] = true
          update_attributes(:the_role => role.to_yaml)
        end

        def rule_off section_name, rule_name
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          return true  unless role[section_name][rule_name]
          role[section_name][rule_name] = false
          update_attributes(:the_role => role.to_yaml)
        end

        # D

        def delete_section section_name = nil
          return false unless section_name
          role         =  to_hash
          section_name =  param_prepare(section_name)
          return false if section_name.blank?
          return false unless role[section_name]
          role.delete  section_name
          update_attributes(:the_role => role.to_yaml)
        end

        def delete_rule section_name, rule_name
          role         = to_hash
          rule_name    = param_prepare(rule_name)
          section_name = param_prepare(section_name)
          return false unless role[section_name]
          return false unless role[section_name].key? rule_name
          role[section_name].delete rule_name
          update_attributes(:the_role => role.to_yaml)
        end
      end
    end
  end#RoleModel

  # for application controller
  # @object_for_ownership_checking should be defined with before_filter
  # @object_for_ownership_checking = @page
  module Requires
    private
    
      def role_access_denied
        flash[:error] = t('the_role.access_denied')
        redirect_to root_path
      end
      
      # before_filter :role_require
      def role_require
        role_access_denied unless current_user.has_role?(controller_name, action_name)
      end

      # before_filter :simple_object_finder
      # define class variable for *owner_require* filter with Controller class name
      # @object_for_ownership_checking = @article
      def simple_object_finder
        variable_name                  = self.class.to_s.tableize.split('_').first.singularize.split('/').last
        @object_for_ownership_checking = self.instance_variable_get("@#{variable_name}")
      end

      # before_filter :owner_require
      def owner_require
        role_access_denied unless current_user.owner?(@object_for_ownership_checking)
      end
  end#Requires
end