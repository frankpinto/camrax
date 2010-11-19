# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101119035210) do

  create_table "authors", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "dates"
  end

  create_table "authors_books", :id => false, :force => true do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  create_table "books", :force => true do |t|
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "full_title"
    t.string   "publication_location"
    t.string   "publisher"
    t.string   "date"
    t.string   "endline"
    t.text     "notes"
    t.string   "short_title"
    t.string   "printer"
    t.string   "number_of_pages"
    t.string   "size"
    t.string   "condition"
    t.string   "brief_description"
    t.string   "full_description"
    t.string   "location_of_original"
    t.datetime "created_at"
    t.datetime "modified_at"
    t.string   "origin"
    t.string   "submitted_by"
    t.string   "isbn"
    t.string   "rrs"
    t.text     "bibliography"
    t.string   "id_number"
    t.string   "spare1"
    t.string   "spare2"
    t.boolean  "modern"
  end

  create_table "books_categories", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "category_id"
  end

  create_table "books_subcategories", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "subcategory_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "alias"
    t.string   "authorities"
    t.text     "body"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "languages", :force => true do |t|
    t.string  "language"
    t.string  "words"
    t.integer "category_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subcategories", :force => true do |t|
    t.string  "title"
    t.integer "category_id"
  end

end
