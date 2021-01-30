class AddCategoriesCounterToClaims < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :categories_count, :integer
  end
end
