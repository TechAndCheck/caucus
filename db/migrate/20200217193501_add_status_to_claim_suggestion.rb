class AddStatusToClaimSuggestion < ActiveRecord::Migration[6.0]
  def change
    change_table :category_suggestions do |t|
      # Set status, 0 is awaiting_review, 1, rejected, 1, approved
      # Take a look at the CategorySuggestions model
      t.integer :status, default: 0
    end
  end
end
