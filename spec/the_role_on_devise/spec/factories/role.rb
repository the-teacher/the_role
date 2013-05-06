#############################################
# USER role
#############################################
user_role = {
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
  factory :role_user, class: Role do
    name        'user'
    title       'User role'
    description 'Default Role for users'
    the_role     user_role
  end
end

#############################################
# MODERATOR role
#############################################

moderator_role = {
  pages: {
    moderator: true
  }
}

FactoryGirl.define do
  factory :role_moderator, class: Role do
    name        'pages_moderator'
    title       'Pages moderator'
    description 'Can do anything with pages'
    the_role     moderator_role
  end
end
















# basic_role = {
#   :pages => {
#     :index   => true,
#     :show    => true,
#     :new     => true,
#     :edit    => true,
#     :update  => true,
#     :destroy => true
#   }
# }

# custom_role = {
#   :pages => {
#     :index   => true,
#     :show    => true,
#     :new     => false,
#     :edit    => false,
#     :update  => false,
#     :destroy => false
#   },
#   :articles => {
#     :index   => true,
#     :show    => true
#   }
# }

# pages_min = {
#   :pages => {
#     :index => false
#   }
# }



# pages_moderator = {
#   :moderator => {
#     :pages => true
#   }
# }

# admin_role = {
#   :system => {
#     :administrator => true
#   }
# }

# Role.create(:name => 'empty', :title => 'empty', :description =>'empty', :the_role => custom_role.to_json)

  # factory :role_with_errors, :class => Role do; end

  # factory :role do
  #   name        'empty'
  #   title       'empty'
  #   description 'empty'
  #   the_role    "#{Hash.new.to_json}"
  # end

  # factory :custom_role, :class => Role do
  #   name        'custom_role'
  #   title       'custom user role'
  #   description 'custom user role set'
  #   the_role     custom_role.to_json
  # end

  # factory :base_user_role, :class => Role do
  #   name        'user'
  #   title       'user'
  #   description 'user role'
  #   the_role     user_role.to_json
  # end

  # factory :pages_moderator_role, :class => Role do
  #   name        'pages_moderator'
  #   title       'moderator of pages'
  #   description 'moderator of pages'
  #   the_role     pages_moderator.to_json
  # end

  # factory :admin_role, :class => Role do
  #   name        'admin'
  #   title       'system administrator'
  #   description 'system administrator'
  #   the_role     admin_role.to_json
  # end

  # factory :pages_min, :class => Role do
  #   name        'pages_min'
  #   title       'pages_min'
  #   description 'pages_min'
  #   the_role     pages_min.to_json
  # end

# end