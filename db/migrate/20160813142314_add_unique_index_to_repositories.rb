class AddUniqueIndexToRepositories < ActiveRecord::Migration[5.0]
  def change
    add_index :repositories, :full_name, unique: true
  end
end
