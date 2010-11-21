class Woops < ActiveRecord::Migration
  def self.up
    rename_column :categories, :redirect, :redirect_id
  end

  def self.down
    rename_column :categories, :redirect_id, :redirect
  end
end
