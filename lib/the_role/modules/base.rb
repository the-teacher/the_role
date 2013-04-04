module TheRole
  module Base
    def has_section? section_name
      hash         =  role_hash
      section_name =  param_prepare section_name
      return true  if hash[section_name]
      false
    end

    def has_role? section_name, rule_name
      hash         =  role_hash
      section_name =  param_prepare(section_name)
      rule_name    =  param_prepare(rule_name)  
      
      if hash['system'].try(:[], 'administrator')
        # next lines are for some admin functionality restrictions
        # useful for almost almighty roles
        hash_rule = hash[section_name].try(:[], rule_name)
        return (hash_rule.nil? ? true : hash_rule)
      end
      
      return true  if hash['moderator'].try(:[], section_name)
      
      return false unless hash[section_name]
      return false unless hash[section_name].key? rule_name
      hash[section_name][rule_name]
    end

    def moderator? section_name
      section_name = param_prepare(section_name)
      has_role? section_name, 'any_crazy_name'
    end

    def admin?
      has_role? 'any_crazy_name', 'any_crazy_name'
    end
  end
end
