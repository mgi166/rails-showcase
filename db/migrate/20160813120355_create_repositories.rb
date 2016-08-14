class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.string :full_name, null: false
      t.string :description
      t.string :html_url
      t.integer :stargazers_count
      t.integer :forks_count
      t.references :user, foreign_key: true
    end
  end
end
