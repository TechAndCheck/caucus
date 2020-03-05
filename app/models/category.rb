class Category < ApplicationRecord
  has_and_belongs_to_many :claims
  validates :name, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_name,
                    against: [:name],
                    using: {
                      trigram: {},
                      tsearch: { dictionary: "english" },
                      dmetaphone: {}
                    },
                    ignoring: :accents
end
