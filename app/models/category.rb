class Category < ActiveRecord::Base
  # Associations
  has_many :languages
  has_many :subcategories
  belongs_to :redirect, :class_name => 'Category', :foreign_key => 'redirect_id'

  accepts_nested_attributes_for :languages
end
