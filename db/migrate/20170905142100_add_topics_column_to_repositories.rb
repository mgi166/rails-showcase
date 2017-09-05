class AddTopicsColumnToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :topics, :string, array: true, null: false, default: []
  end
end
