require "test_helper"

class CategorySuggestionTest < ActiveSupport::TestCase
  test "A category suggestion should be able to be approved" do
    suggestion = CategorySuggestion.create({ name: "Test", claim: claims(:one), user: users(:one) })
    suggestion.approve

    assert_equal "approved", suggestion.status, "A category suggestion should be able to be approved"
  end

  test "A category suggestion should be able to be rejected" do
    suggestion = CategorySuggestion.create({ name: "Test", claim: claims(:one), user: users(:one) })
    suggestion.reject

    assert_equal "rejected", suggestion.status, "A category suggestion should be able to be rejected"
  end

  test "A should be created when a category suggestion is approved" do
    suggestion = CategorySuggestion.create({ name: "Test", claim: claims(:one), user: users(:one) })
    suggestion.approve

    category = Category.where(name: suggestion.name)

    assert category.size > 0, "Category should be created when a category suggestion is approved"
  end
end
