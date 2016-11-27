class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :full_name, presence: true

  scope :order_by_stargazers, -> { order('stargazers_count DESC') }
end
