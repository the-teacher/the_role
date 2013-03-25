require 'haml'

require 'the_role/param_helper'
require 'the_role/hash'

require 'the_role/engine'
require 'the_role/version'
require 'the_role/the_class_exists'

require 'the_role/modules/base'
require 'the_role/modules/user_model'
require 'the_role/modules/role_model'
require 'the_role/modules/controller_requires'
require 'the_role/config'

module TheRole
  class Engine < Rails::Engine; end
  # include TheRole::Base
  # include TheRole::Requires
  # include TheRole::UserModel
  # include TheRole::RoleModel
  # include TheRole::ParamHelper
end