# This represents a claim that is being categorized, it's based on
# the fact_check model from FactStream, but can be also be
# categorized separatetly. If it does refer to a fact check the
# fact_check_id is populated with the one from the FactStream
# database.

class Claim < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :category_suggestions

  validates :fact_stream_id, uniqueness: true, allow_nil: true

  before_save :deduplicate_categories, :update_categories_count

  # Manage the category claims counter manually because `cache_counter` isn't a great idea for HABTM
  def update_categories_count(save = false)
    self.categories_count = self.categories.count
    self.save! if save == true
  end

private

  # Insure there's not more than one category in categories
  def deduplicate_categories
    self.categories = self.categories.uniq
  end
end
