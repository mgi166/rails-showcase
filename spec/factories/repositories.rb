FactoryGirl.define do
  factory :repository do
    user
    sequence(:name) { |n| "repo#{n}" }
    sequence(:full_name) { |n| "username/repo#{n}" }
    sequence(:html_url) { |n| "https://github.com/username/repo#{n}" }
    description "description"
    stargazers_count 20
    forks_count 10
  end
end
