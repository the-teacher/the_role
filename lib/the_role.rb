require 'haml'

require 'the_role/hash'
require 'the_role/config'
require 'the_role/version'
require 'the_role/param_helper'

module TheRole
  class Engine < Rails::Engine
    # initializer "TheRole precompile hook", group: :all do |app|
    #   app.config.assets.precompile += %w( x.js y.css )
    # end

    # http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
    # config.to_prepare do; end
  end
end