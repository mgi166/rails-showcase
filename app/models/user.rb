class User < ApplicationRecord
  has_many :repositories

  validates :login, presence: true
end
