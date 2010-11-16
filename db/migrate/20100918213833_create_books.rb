class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.integer :category_id
      t.integer :subcategory_id
      t.boolean :modern, :default => false
      t.string :title
      t.string :location
      t.string :publisher
      t.string :date
      t.string :endline
      t.text :notes

    end

    create_table :authors_books, :id => false do |t|
      t.integer :author_id
      t.integer :book_id

    end

    create_table :books_categories, :id => false do |t|
      t.integer :book_id
      t.integer :category_id

    end

    create_table :books_subcategories, :id => false do |t|
      t.integer :book_id
      t.integer :subcategory_id

    end

  end

  def self.down
    drop_table :books
    drop_table :authors_books
    drop_table :books_categories
    drop_table :books_subcategories
  end
end
