class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :full_name, presence: true

  scope :order_by_stargazers, -> { order('stargazers_count DESC') }
  scope :search_with_full_name, -> (full_name) { where(arel_table[:full_name].matches("%#{escape_like(full_name)}%")) }
  scope :search_order_by, -> (order) {
    by = ORDER_BY.include?(order.to_s) ? order.to_s : 'id'
    order(arel_table[by].desc)
  }

  ORDER_BY = %w(stargazers_count forked_count pushed_at)

  def self.search(params)
    if params[:search].present? && params[:repo_or_username].present?
      Repository.with_like_full_name(params[:repo_or_username]).includes(:user).page(params[:page])
    else
      Repository.order_by_stargazers.includes(:user).page(params[:page])
    end
  end

  private

  def self.escape_like(str)
    str.gsub(/[\\%_]/) { |match| "\\#{match}" }
  end
end
