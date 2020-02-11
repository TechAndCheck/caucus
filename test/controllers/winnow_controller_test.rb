require "test_helper"

class WinnowControllerTest < ActionDispatch::IntegrationTest
  test "Should get index" do
    get root_url
    assert_response :success
  end

  test "Should add categories to claim" do
    claim = Claim.last
    category = Category.last

    # This endpoint expects a lit of category ids, in a comma-seperated string
    patch winnow_submit_url(claim), params: { claim: { id: "#{claim.id}", categories: "#{category.id}" } }

    assert claim.categories.include?(category), "Category should have been added to claim"

    assert_redirected_to root_url
  end

  test "Should return 404 if claim is not found" do
    claim = Claim.last
    category = Category.last

    # This endpoint expects a lit of category ids, in a comma-seperated string
    patch winnow_submit_url(claim), params: { claim: { id: "1234", categories: "#{category.id}" } }

    assert_response :not_found, "Should return 404 if there is no claim found"
  end
end
