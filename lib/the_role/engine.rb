require 'the_role'
require 'rails'

module TheRole
  class Engine < Rails::Engine
    config.to_prepare do
      Role.send :include, TheRole::RoleModel if the_class_exists? :Role
      User.send :include, TheRole::UserModel if the_class_exists? :User
      ApplicationController.send :include, TheRole::Requires if the_class_exists? :ApplicationController
    end
  end
end