class RemoveFullNameColumnFromRepositories < ActiveRecord::Migration[5.1]
  def change
    remove_column :repositories, :full_name
  end
end
