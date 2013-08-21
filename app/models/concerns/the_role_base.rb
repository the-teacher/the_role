module TheRoleBase
  def has_section? section_name
    hash         =  role_hash
    section_name =  TheRoleParam.process section_name
    return true  if hash[section_name]
    false
  end

  def has_role? section_name, rule_name
    hash         =  role_hash
    section_name =  TheRoleParam.process(section_name)
    rule_name    =  TheRoleParam.process(rule_name)

    return true  if hash.try(:[], 'system').try(:[], 'administrator')
    return true  if hash.try(:[], 'moderator').try(:[], section_name)

    return false unless hash[section_name]
    return false unless hash[section_name].key? rule_name
    hash[section_name][rule_name]
  end

  def any_role? roles_hash = {}
    roles_hash.each_pair{|section, action| return true if has_role?(section, action)}
    false
  end

  def moderator? section_name
    section_name = TheRoleParam.process(section_name)
    has_role? section_name, TheRole.config.admin_role_name
  end

  def admin?
    has_role? TheRole.config.admin_role_name, TheRole.config.admin_role_name
  end
end