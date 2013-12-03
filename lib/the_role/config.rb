module TheRole
  def self.configure(&block)
    yield @config ||= TheRole::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :layout,
                    :user_model,
                    :default_user_role,
                    :dependent_destroy,
                    :first_user_should_be_admin
                    
  end

  configure do |config|
    config.layout                     = :application
    config.default_user_role          = nil
    config.first_user_should_be_admin = false
    config.user_model                 = :user
    config.dependent_destroy          = :restrict_with_exception
  end
end