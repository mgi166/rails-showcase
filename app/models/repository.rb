class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :full_name, presence: true

  scope :order_by_stargazers, -> { order('stargazers_count DESC') }
  scope :search_with_full_name, -> (full_name) {
    where(arel_table[:full_name].matches("%#{escape_like(full_name)}%")) if full_name.present?
  }
  scope :search_order_by, -> (order) {
    column_name = ::Settings.repository.orders.include?(order.to_s) ? order.to_s : 'id'
    order(arel_table[column_name].desc)
  }

  def self.index(params)
    Repository
      .search_with_full_name(params[:repo_or_username])
      .search_order_by(params[:order])
      .includes(:user)
      .page(params[:page])
  end

  private

  def self.escape_like(str)
    str.gsub(/[\\%_]/) { |match| "\\#{match}" }
  end
end
