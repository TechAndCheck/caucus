require "test_helper"

class WinnowControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should get index" do
    sign_in users(:one)

    get winnow_index_path
    assert_response :success
  end

  test "Should add categories to claim" do
    sign_in users(:one)

    claim = Claim.last
    category = Category.last

    # This endpoint expects a lit of category ids and suggestion names, in a comma-seperated string
    patch winnow_submit_url(claim), params: { claim: { id: "#{claim.id}", categories: "#{category.id}", suggestions: "#{"test suggestion"}" } }

    claim.reload

    assert claim.categories.include?(category), "Category should have been added to claim"
    assert claim.checked, "Category should be marked as checked"

    assert_redirected_to winnow_index_path
  end

  test "Should create category suggestions when updating claim" do
    sign_in users(:one)

    claim = Claim.last
    category = Category.last

    # This endpoint expects a lit of category ids and suggestion names, in a comma-seperated string
    patch winnow_submit_url(claim), params: { claim: { id: "#{claim.id}", categories: "#{category.id}", suggestions: "#{"test suggestion"}" } }

    assert_equal "test suggestion", CategorySuggestion.last.name, "A category suggestion should be created"
    assert_equal users(:one), CategorySuggestion.last.user, "A category suggestion should have the currently signed in user"
    assert_equal claim, CategorySuggestion.last.claim, "A category suggestion should have the current claim"
  end

  test "Should return 404 if claim is not found" do
    claim = Claim.last
    category = Category.last

    # This endpoint expects a lit of category ids, in a comma-seperated string
    patch winnow_submit_url(claim), params: { claim: { id: "1234", categories: "#{category.id}" } }

    assert_response :not_found, "Should return 404 if there is no claim found"
  end
end
