class AddArticleToClaim < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :article, :text
  end
end
