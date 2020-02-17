class CreateCategorySuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :category_suggestions do |t|
      t.string :name
      t.belongs_to :user
      t.belongs_to :claim
      t.belongs_to :category
      t.timestamps
    end
  end
end
