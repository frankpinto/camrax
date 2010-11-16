class Author < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :books
end
