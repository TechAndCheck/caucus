class Category < ApplicationRecord
  has_and_belongs_to_may :claims
end
