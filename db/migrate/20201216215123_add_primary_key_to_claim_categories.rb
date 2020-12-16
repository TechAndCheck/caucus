class AddPrimaryKeyToClaimCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories_claims, :id, :integer, primary_key: true
  end
end
