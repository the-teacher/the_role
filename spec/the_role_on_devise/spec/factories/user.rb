FactoryGirl.define do
  factory :user, :class => User do
    sequence(:email)  { Faker::Internet.email         }
    sequence(:name)   { Faker::Name.name              }
    sequence(:company){ Faker::Company.name           }
    sequence(:address){ Faker::Address.street_address }
    sequence(:role_id){ 1 }

    password 'qwerty'
    password_confirmation {|u| u.password}
  end
end