class ChangeDescription < ActiveRecord::Migration
  def self.up
    change_column :books, :brief_description, :text
    change_column :books, :full_description, :text
  end

  def self.down
  end
end
