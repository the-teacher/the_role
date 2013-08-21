module RoleModel
  extend ActiveSupport::Concern

  include TheRoleBase

  def role_hash; to_hash; end
  alias_method :has?, :has_role?
  alias_method :any?, :any_role?

  def has_section? section_name
    to_hash.key? TheRoleParam.process(section_name)
  end

  included do
    has_many  :users
    validates :name,        presence: true, uniqueness: true
    validates :title,       presence: true, uniqueness: true
    validates :description, presence: true

    before_save do
      self.name = TheRoleParam.process(name)

      rules_set = self[TheRole.role_attribute]
      if rules_set.blank?         # blank
        self[TheRole.role_attribute] = {}.to_json
      elsif rules_set.is_a?(Hash) # Hash
        self[TheRole.role_attribute] = rules_set.to_json
      end
    end
  end

  module ClassMethods
    def with_name name
      where(name: name).first
    end
  end

  # C

  def create_section section_name = nil
    return false unless section_name
    role         =  to_hash
    section_name =  TheRoleParam.process(section_name)
    return false if section_name.blank?
    return true  if role[section_name]
    role[section_name] = {}
    update(TheRole.role_attribute => role)
  end

  def create_rule section_name, rule_name
    return false if     rule_name.blank?
    return false unless create_section(section_name)
    role         =  to_hash
    rule_name    =  TheRoleParam.process(rule_name)
    section_name =  TheRoleParam.process(section_name)
    return true  if role[section_name][rule_name]
    role[section_name][rule_name] = false
    update(TheRole.role_attribute => role)
  end

  # R

  def to_hash
    begin JSON.load(self[TheRole.role_attribute]) rescue {} end
  end

  def to_json
    self[TheRole.role_attribute]
  end

  # U

  # source_hash will be reset to false
  # except true items from new_role_hash
  # all keys will become 'strings'
  # look at lib/the_role/hash.rb to find definition of *underscorify_keys* method
  def update_role new_role_hash
    new_role_hash = new_role_hash.try(:to_hash) || {}
    new_role      = new_role_hash.underscorify_keys
    role          = to_hash.underscorify_keys.deep_reset(false)
    role.deep_merge! new_role
    update(TheRole.role_attribute => role)
  end

  def rule_on section_name, rule_name
    role         =  to_hash
    rule_name    =  TheRoleParam.process(rule_name)
    section_name =  TheRoleParam.process(section_name)
    return false unless role[section_name]
    return false unless role[section_name].key? rule_name
    return true  if     role[section_name][rule_name]
    role[section_name][rule_name] = true
    update(TheRole.role_attribute => role)
  end

  def rule_off section_name, rule_name
    role         = to_hash
    rule_name    = TheRoleParam.process(rule_name)
    section_name = TheRoleParam.process(section_name)
    return false unless role[section_name]
    return false unless role[section_name].key? rule_name
    return true  unless role[section_name][rule_name]
    role[section_name][rule_name] = false
    update(TheRole.role_attribute => role)
  end

  # D

  def delete_section section_name = nil
    return false unless section_name
    role         =  to_hash
    section_name =  TheRoleParam.process(section_name)
    return false if section_name.blank?
    return false unless role[section_name]
    role.delete  section_name
    update(TheRole.role_attribute => role)
  end

  def delete_rule section_name, rule_name
    role         = to_hash
    rule_name    = TheRoleParam.process(rule_name)
    section_name = TheRoleParam.process(section_name)
    return false unless role[section_name]
    return false unless role[section_name].key? rule_name
    role[section_name].delete rule_name
    update(TheRole.role_attribute => role)
  end
end