require 'the_role/hash'
require 'the_role/config'
require 'the_role/version'
require 'the_role/activerecord'

require 'the_string_to_slug'

module TheRole
  class << self
    def create_admin_role!
      admin_role = ::Role.where(name: :admin).first_or_create!(
          name: :admin,
          title: "Role for admin",
          description: "This user can do anything"
      )
      admin_role.create_rule(:system, :administrator)
      admin_role.rule_on(:system, :administrator)
      admin_role
    end
  end

  class Engine < Rails::Engine
    # initializer "TheRole precompile hook", group: :all do |app|
    #   app.config.assets.precompile += %w( x.js y.css )
    # end

    # http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
    # config.to_prepare do; end
  end
end

_root_ = File.expand_path('../../',  __FILE__)

# Loading of concerns
require "#{_root_}/config/routes.rb"
require "#{_root_}/app/controllers/concerns/controller.rb"

%w[ base role user ].each do |concern|
  require "#{_root_}/app/models/concerns/#{concern}.rb"
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend TheRole::ActiveRecord
end