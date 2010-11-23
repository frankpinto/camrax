class Book < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :authors
  belongs_to :category
  belongs_to :subcategory

  def category_title
    category.title if category
  end

  def subcategory_title
    category.title if category
  end

  def category_title=(name)
    self.category = Category.find_or_create_by_title(name) unless name.blank?
  end

  def subcategory_title=(name)
    self.category = Category.find_or_create_by_title(name) unless name.blank?
  end
end
