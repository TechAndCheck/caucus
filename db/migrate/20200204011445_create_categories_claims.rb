class CreateCategoriesClaims < ActiveRecord::Migration[6.0]
  def change
    create_join_table :categories, :claims do |t|
      t.index :category_id
      t.index :claim_id
    end
  end
end
