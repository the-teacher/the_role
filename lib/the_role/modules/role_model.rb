module TheRole
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
          the_role
        end

        def to_s
          the_role
        end

        # U

        # source_hash will be reset to false
        # except true items from new_role_hash
        # all keys will become symbols
        # look at lib/the_role/hash.rb to find definition of *underscorify_keys* method
        def update_role new_role_hash
          return true unless new_role_hash.instance_of? Hash
          new_role    = new_role_hash.underscorify_keys
          role        = to_hash.underscorify_keys.deep_reset
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
  end
end