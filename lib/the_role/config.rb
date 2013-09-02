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
                    :default_user_role,
                    :first_user_should_be_admin
  end

  configure do |config|
    config.layout                     = :application
    config.default_user_role          = nil
    config.first_user_should_be_admin = false
  end
end