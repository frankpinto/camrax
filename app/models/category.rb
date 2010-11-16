class Category < ActiveRecord::Base
  # Associations
  has_many :languages
  has_many :subcategories

  accepts_nested_attributes_for :languages
end
