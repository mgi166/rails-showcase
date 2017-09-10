FactoryGirl.define do
  factory :repository do
    user
    sequence(:name) { |n| "repo#{n}" }
    sequence(:name_with_owner) { |n| "username/repo#{n}" }
    sequence(:html_url) { |n| "https://github.com/username/repo#{n}" }
    sequence(:url) { |n| "https://github.com/username/repo#{n}" }
    description "description"
    stargazers_count 20
    forks_count 10
    repo_created_at Time.current
  end
end
