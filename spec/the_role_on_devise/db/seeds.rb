Role.destroy_all
User.destroy_all

Role.create!(
  name: :user,
  title: :role_for_users,
  description: :user_can_edit_his_pages,
  the_role: {
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
)

Role.create!(
  name: :admin,
  title: :admin_role,
  description: :god_of_this_system,
  the_role: { system: { administrator: true } }
)


User.create!(
  email: Faker::Internet.email,
  name:  Faker::Name.name,
  company: Faker::Company.name,
  address: Faker::Address.street_address,
  password: 'qwerty',
  password_confirmation: 'qwerty',
  role: Role.with_name(:admin)
)

5.times do
  User.create!(
    email: Faker::Internet.email,
    name:  Faker::Name.name,
    company: Faker::Company.name,
    address: Faker::Address.street_address,
    password: 'qwerty',
    password_confirmation: 'qwerty'
  )
end