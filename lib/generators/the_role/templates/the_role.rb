# TheRole.config.param_name = value

TheRole.configure do |c|
  c.layout            = :application     # default Layout for TheRole UI
  c.default_user_role = nil              # set default role (name)
  c.admin_role_name   = 'any_crazy_name' # Admin role name can be changed
  c.role_class_name   = 'Role'           # Role class can be changed (e.g., 'UserRole')
  c.role_attribute    = :the_role        # Role attribute/database column can be changed (e.g., :role, :role_hash)
end