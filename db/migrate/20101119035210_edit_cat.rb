class EditCat < ActiveRecord::Migration
  def self.up
    drop_table :tests

    add_column :categories, :created_at, :datetime
    add_column :categories, :modified_at, :datetime
  end

  def self.down
    remove_column :categories, :created_at
    remove_column :categories, :modified_at
  end
end
