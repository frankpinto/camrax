class Book < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :subcategories
end
