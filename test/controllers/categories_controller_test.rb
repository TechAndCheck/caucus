require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "get categories should work" do
    get categories_path
    assert :success, "Categories list should work"
  end

  test "show new categories should work" do
    get new_category_path
    assert :success, "New category page should work"
  end

  test "create new categories should work" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: "Test Name" } }
    end

    assert_redirected_to category_path(Category.last)
    assert_not_empty flash[:success]
  end

  test "update category should work" do
    patch category_url(Category.last), params: { category: { name: "New Name" } }
    assert_equal "New Name", Category.last.name
    assert_not_empty flash[:success]
  end

  test "delete category should work" do
    assert_difference("Category.count", -1) do
      delete category_url(Category.last)
    end

    assert_redirected_to categories_path
    assert_not_empty flash[:success]
  end

  test "accessing non-existent category should produce error" do
    get category_url(1234)
    assert_redirected_to categories_path, "Should be redirected if getting non-existent category"
    assert_not_empty flash[:error]

    get category_url(1234)
    assert_redirected_to categories_path, "Should be redirected if updating non-existent category"
    assert_not_empty flash[:error]

    patch category_url(1234), params: { category: { name: "New Name" } }
    assert_redirected_to categories_path, "Should be redirected if deleting non-existent category"
    assert_not_empty flash[:error]
  end
end
