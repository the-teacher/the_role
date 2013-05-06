require "active_support/inflector"

# TheRoleParam.process 'hello world'

module TheRoleParam
  def self.process param
    param.to_s.parameterize.underscore
  end
end
