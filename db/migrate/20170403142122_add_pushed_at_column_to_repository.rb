class AddPushedAtColumnToRepository < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :pushed_at, :datetime
    add_index :repositories, [:pushed_at]
  end
end
