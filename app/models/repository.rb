class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name_with_owner, presence: true
  validates :url, presence: true

  scope :order_by_stargazers, -> { order(stargazers_count: :desc) }
  scope :search_with_name_with_owner, -> (name_with_owner) {
    where(arel_table[:name_with_owner].matches("%#{escape_like(name_with_owner)}%")) if name_with_owner.present?
  }
  scope :search_order_by, -> (order) {
    column_name = ::Settings.repository.orders.include?(order.to_s) ? order.to_s : 'stargazers_count'
    order(column_name => :desc)
  }

  before_validation :set_url

  def self.index(params)
    Repository
      .search_with_name_with_owner(params[:repo_or_username])
      .search_order_by(params[:order])
      .includes(:user)
      .page(params[:page])
  end

  private

  def self.escape_like(str)
    str.gsub(/[\\%_]/) { |match| "\\#{match}" }
  end

  def set_url
    self.url = "https://github.com/#{name_with_owner}" if name_with_owner.present?
  end
end
