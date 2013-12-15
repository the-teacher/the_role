FactoryGirl.define do
  factory :page, class: Page do
    sequence(:title)   { Faker::Lorem.sentence           }
    sequence(:content) { Faker::Lorem.paragraphs(3).join }
  end
end