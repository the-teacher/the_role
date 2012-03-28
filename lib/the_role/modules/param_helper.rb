module TheRole
  module ParamHelper
    def param_prepare param
      param.to_s.parameterize.underscore.to_sym
    end
  end
end