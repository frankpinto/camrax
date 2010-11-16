class Language < ActiveRecord::Base
  # Associations
  has_one :category
end
