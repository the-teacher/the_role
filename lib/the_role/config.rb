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
    config_accessor :layout, :default_user_role
  end

  configure do |config|
    config.layout = :application
    config.default_user_role = nil
  end
end