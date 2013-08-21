module TheRole
  def self.configure(&block)
    yield @config ||= TheRole::Configuration.new
  end

  def self.config
    @config
  end

  def self.role_class
    @@role_class ||= TheRoleParam.constantize(config.role_class_name)
  end

  def self.role_attribute
    @@role_attribute ||= TheRole.config.role_attribute.to_sym
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :layout,
                    :default_user_role,
                    :default_admin_role_name,
                    :role_class,
                    :role_attribute
  end

  configure do |c|
    c.layout            = :application
    c.default_user_role = nil
    c.admin_role_name   = 'any_crazy_name'
    c.role_class_name   = 'Role'
    c.role_attribute    = :the_role
  end
end