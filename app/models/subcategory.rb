class Subcategory < ActiveRecord::Base
  # Associations
  has_one :category
end
