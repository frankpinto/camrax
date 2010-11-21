class FixFields < ActiveRecord::Migration
  def self.up
    add_column :books, :cover_file_name, :string
    add_column :books, :cover_content_type, :string
    add_column :books, :language, :string
    change_column :books, :rrs, :boolean

    rename_column :categories, :alias, :redirect_id
    change_column :categories, :redirect_id, :integer
  end

  def self.down
    remove_column :books, :cover_file_name
    remove_column :books, :cover_content_type
    remove_column :books, :language
    change_column :books, :rrs, :string

    rename_column :categories, :redirect_id, :alias
    change_column :categories, :alias, :string
  end
end
