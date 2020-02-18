class CategorySuggestion < ApplicationRecord
  belongs_to :user
  belongs_to :claim
  belongs_to :category, optional: true

  before_create :titleize_name

  enum status: [ :awaiting_review, :rejected, :approved ]

  validates :status, inclusion: { in: self.statuses,
    message: "%{value} is not a valid status" }

  def approve
    category = create_and_attach_category
    self.update({ status: :approved, category: category })
  end

  def assign_similar_category(category)
    self.claim.categories << category
    self.update({ status: :approved, category: category })
  end

  def reject
    self.update({ status: :rejected })
  end

  def similar_categories
    Category.search_by_name(self.name)
  end


private

  def create_and_attach_category
    category = Category.create({ name: self.name })
    begin
      self.claim.categories << category
    rescue ActiveRecord::RecordInvalid
      # If this validation fails it's not a big deal.
    end

    category
  end

  def titleize_name
    self.name = self.name.titleize
  end
end
