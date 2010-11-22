class Subcategory < ActiveRecord::Base
  # Associations
  has_one :category
  has_many :books
end
