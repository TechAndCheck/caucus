class Category < ApplicationRecord
  has_and_belongs_to_many :claims
  validates :name, uniqueness: true

  before_save :update_claims_count
  after_destroy :update_claims_category_counters

  include PgSearch::Model
  pg_search_scope :search_by_name,
                    against: [:name],
                    using: {
                      trigram: {},
                      tsearch: { dictionary: "english" },
                      dmetaphone: {}
                    },
                    ignoring: :accents


  # Manage the claims counter manually because `cache_counter` isn't a great idea for HABTM
  def update_claims_count(save = false)
    self.claims_count = self.claims.count
    self.save! if save == true
  end

private

  def update_claims_category_counters
    self.claims.each do |claim|
      update_categories_count(true)
    end
  end

end
