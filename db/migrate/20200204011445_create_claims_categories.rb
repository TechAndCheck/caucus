class CreateClaimsCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :claims_categories, id: false do |t|
      t.belongs_to :claim
      t.belongs_to :category
      t.timestamps
    end
  end
end
