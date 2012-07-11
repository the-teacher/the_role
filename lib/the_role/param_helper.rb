require "active_support/inflector"

# TheRole::ParamHelper.prepare 'hello world'

module TheRole
  module ParamHelper
    def param_prepare param
      param.to_s.parameterize.underscore
    end

    def self.prepare param
      param.to_s.parameterize.underscore
    end
  end
end