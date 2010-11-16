class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title, :null => false
      t.string :alias
      t.string :authorities
      t.text :body
      t.text :extra

    end
  end

  def self.down
    drop_table :categories
  end
end
