class AddClaimsCounterToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :claims_count, :integer
  end
end
