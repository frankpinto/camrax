class Category < ActiveRecord::Base
  # Associations
  has_many :languages
  has_many :subcategories

  accepts_nested_attributes_for :languages

  def redirect?
    if this.alias.empty?
      return false
    else
      return true
    end
  end
end
