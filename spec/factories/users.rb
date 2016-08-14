FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "username#{n}" }
    sequence(:html_url) { |n| "https://github.com/username#{n}" }
    sequence(:avatar_url) { |n| "https://avatars0.githubusercontent.com/u/#{n}" }
  end
end
