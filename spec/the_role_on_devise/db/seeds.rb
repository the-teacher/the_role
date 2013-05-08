Role.destroy_all
User.destroy_all
Page.destroy_all

##############################
# Roles
##############################
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

Role.create!(
  name: :pages_moderator,
  title: :pages_moderator,
  description: :can_do_anything_with_pages,
  the_role: { moderator: { pages: true } }
)

p "Roles created"

##############################
# Users
##############################
User.create!(
  email: Faker::Internet.email,
  name:  Faker::Name.name,
  company: Faker::Company.name,
  address: Faker::Address.street_address,
  password: 'qwerty',
  password_confirmation: 'qwerty',
  role: Role.with_name(:admin)
)

User.create!(
  email: Faker::Internet.email,
  name:  Faker::Name.name,
  company: Faker::Company.name,
  address: Faker::Address.street_address,
  password: 'qwerty',
  password_confirmation: 'qwerty',
  role: Role.with_name(:pages_moderator)
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

p "Users created"

##############################
# Pages
##############################

User.all.each do |user|
  10.times do 
    user.pages.create!(
      title:   Faker::Lorem.sentence,
      content: Faker::Lorem.paragraphs(3).join,
      state: %w[draft published].sample
    )
  end
end

p "Pages created"