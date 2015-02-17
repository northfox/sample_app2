FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "hellooo"
    password_confirmation"hellooo"

    factory :admin do
      admin true
    end
  end
end
