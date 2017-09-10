class AddRepoCreatedAtToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :repo_created_at, :datetime
  end
end
