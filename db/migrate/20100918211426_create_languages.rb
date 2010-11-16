class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.integer :page_id
      t.string :language
      t.string :words

    end
  end

  def self.down
    drop_table :languages
  end
end
