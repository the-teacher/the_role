class Role
  include Mongoid::Document

  field :name, type: String
  field :title, type: String
  field :description, type: String
  field :the_role, type: String

  include RoleModel
end
