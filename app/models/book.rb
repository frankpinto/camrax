class Book < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :authors
  has_one :categories
  has_one :subcategories
end
