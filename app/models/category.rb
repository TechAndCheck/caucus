class Category < ApplicationRecord
  has_and_belongs_to_many :claims
  validates :name, uniqueness: true

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

private

  def update_claims_category_counters
    self.claims.each do |claim|
      update_categories_count(true)
    end
  end

end
