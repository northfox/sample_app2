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

  factory :micropost do
    sequence(:content) { |n| "Lorem ipsum #{n}" }
    user
  end
end
