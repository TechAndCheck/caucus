# This represents a claim that is being categorized, it's based on
# the fact_check model from FactStream, but can be also be
# categorized separatetly. If it does refer to a fact check the
# fact_check_id is populated with the one from the FactStream
# database.

class Claim < ApplicationRecord
  has_and_belongs_to_many :categories
end
