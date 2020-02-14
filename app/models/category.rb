class Category < ApplicationRecord
  has_and_belongs_to_many :claims
  validates :name, uniqueness: true
end
