class AddNameWithOwnerColumnToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :name_with_owner, :string, null: false
  end
end
