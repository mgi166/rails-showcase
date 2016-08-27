# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

gitlabhq = User.find_or_create_by!(
  login: 'gitlabhq',
  html_url: 'https://github.com/gitlabhq',
  avatar_url: 'https://avatars2.githubusercontent.com/u/1086321?v=3&s=200',
)

helpyio = User.find_or_create_by!(
  login: 'Helpy',
  html_url: 'https://github.com/helpyio',
  avatar_url: 'https://avatars0.githubusercontent.com/u/17730784?v=3&s=200',
)

Repository.find_or_create_by!(
  name: 'helpy',
  full_name: 'helpyio/helpy',
  description: 'Helpy is a modern, "mobile-first" helpdesk application built in Ruby. Features include multi-lingual knowledgebase, community discussions and private tickets integrated with email. http://helpy.io/?source=ghh',
  html_url: 'https://github.com/helpyio/helpy',
  stargazers_count: 728,
  forks_count: 142,
  user: helpyio,
)

Repository.find_or_create_by!(
  name: 'gitlabhq',
  full_name: 'gitlabhq/gitlabhq',
  description: 'GitLab is version control for your server | Please open issues in our issue tracker on GitLab.com https://gitlab.com/gitlab-org/gitlab-ce
',
  html_url: 'https://github.com/gitlabhq/gitlabhq',
  stargazers_count: 18346,
  forks_count: 4999,
  user: gitlabhq,
)
