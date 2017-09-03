class AddTimestampColumnToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :created_at, :datetime, null: false
    add_column :repositories, :updated_at, :datetime, null: false
  end
end
