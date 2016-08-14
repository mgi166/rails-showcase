class User < ApplicationRecord
  has_many :repositories

  validates :login, presence: true

  accepts_nested_attributes_for :repositories
end
