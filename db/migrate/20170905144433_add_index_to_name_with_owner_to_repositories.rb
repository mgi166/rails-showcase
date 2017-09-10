class AddIndexToNameWithOwnerToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_index :repositories, [:name_with_owner], unique: true
  end
end
