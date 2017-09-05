class AddUrlColumnToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :url, :string, null: false
  end
end
