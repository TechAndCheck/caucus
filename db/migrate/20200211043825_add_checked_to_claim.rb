class AddCheckedToClaim < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :checked, :boolean, default: false
  end
end
