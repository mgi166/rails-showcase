class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :full_name, presence: true

  scope :order_by_stargazers, -> { order('stargazers_count DESC') }
  scope :with_like_full_name, -> (full_name) { where(arel_table[:full_name].matches("%#{escape_like(full_name)}%")) }

  private

  def self.escape_like(str)
    str.gsub(/[\\%_]/) { |match| "\\#{match}" }
  end
end
