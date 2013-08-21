#############################################
# EMPTY role
#############################################
FactoryGirl.define do
  factory :role_without_rules, class: TheRole.role_class do
    name        'user'
    title       'User role'
    description 'Default Role for users'
  end
end

#############################################
# USER role
#############################################
role_user = {
  pages: {
    index:   true,
    show:    true,
    new:     true,
    create:  true,
    edit:    true,
    update:  true,
    destroy: true,
    my:      true,
    secret:  false
  }
}

FactoryGirl.define do
  factory :role_user, class: TheRole.role_class do
    name        'user'
    title       'User role'
    description 'Default Role for users'
    the_role     role_user
  end
end

#############################################
# MODERATOR role
#############################################

role_moderator = {
  moderator: {
    pages: true
  }
}

FactoryGirl.define do
  factory :role_moderator, class: TheRole.role_class do
    name        'pages_moderator'
    title       'Pages moderator'
    description 'Can do anything with pages'
    the_role     role_moderator
  end
end