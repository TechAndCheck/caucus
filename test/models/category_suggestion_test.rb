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

  test "A category suggestion name should be titleized when being updated" do
    suggestion = CategorySuggestion.create({ name: "test name", claim: claims(:one), user: users(:one) })
    assert_equal "Test Name", suggestion.name, "A category suggestion name should be titleized when being created"
  end

  test "A category suggestion name should not be titleized when being edited" do
    suggestion = CategorySuggestion.create({ name: "test name", claim: claims(:one), user: users(:one) })
    assert_equal "Test Name", suggestion.name, "A category suggestion name should be titleized when being created"

    suggestion.update!({ name: "Test name" })
    assert_equal "Test name", suggestion.name, "A category suggestion name should not be titleized when being updated"
  end

  test "Searching for similar categories doesn't raise errors" do
    assert_nothing_raised do
      suggestion = CategorySuggestion.create({ name: "test name", claim: claims(:one), user: users(:one) })
      suggestion.similar_categories
    end
  end

  test "A category can be assigned even if not the suggestion" do
    category = categories(:one)
    claim = claims(:one)
    suggestion = CategorySuggestion.create({ name: "Test", claim: claim, user: users(:one) })
    suggestion.assign_similar_category(category)

    assert_equal category, suggestion.category, "Category should be assigned when a category is assigned"
    assert claim.categories.include?(category), "Claim should now have assigned category"
  end
end
