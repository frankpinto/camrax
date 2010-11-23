class Category < ActiveRecord::Base
  # Associations
  has_many :languages, :dependent => :destroy
  has_many :subcategories
  belongs_to :redirect, :class_name => 'Category', :foreign_key => 'redirect_id'
  has_many :books

  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :books

  def has_bibliography?
    return false if books.empty?
    books.each {|book| return true unless book.modern}
    return false
  end

  def has_modern?
    return false if books.empty?
    books.each {|book| return true if book.modern}
    return false
  end

  def redirect_title
    redirect.title if redirect
  end

  def redirect_title=(name)
    self.redirect = Category.find_or_create_by_title(name) unless name.blank?
  end
end
