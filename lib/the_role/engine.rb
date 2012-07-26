require 'the_role'
require 'rails'

module TheRole
  class Engine < Rails::Engine
    initializer "TheRole precompile hook", :group => :all do |app|
      app.config.assets.precompile += %w( admin_the_role.js admin_the_role.css )
    end
  end
end