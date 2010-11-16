class AddFields < ActiveRecord::Migration
  def self.up
    # Fields not included in this iteration: type, cover, language because I think its already implemented
    add_column :authors, :dates, :string

    add_column :books, :short_title, :string
    rename_column :books, :title, :full_title

    add_column :books, :printer, :string
    add_column :books, :number_of_pages, :string
    add_column :books, :size, :string
    add_column :books, :condition, :string

    add_column :books, :brief_description, :string
    add_column :books, :full_description, :string

    rename_column :books, :location, :publication_location
    add_column :books, :location_of_original, :string

    add_column :books, :created_at, :datetime
    add_column :books, :modified_at, :datetime

    add_column :books, :origin, :string
    add_column :books, :submitted_by, :string

    add_column :books, :isbn, :string

    # Ones I don't fully understand
    add_column :books, :rrs, :string
    add_column :books, :bibliography, :text
    add_column :books, :id_number, :string
    add_column :books, :spare1, :string
    add_column :books, :spare2, :string
  end

  def self.down
  end
end
