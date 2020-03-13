class AddNameToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :name, :string

    # Since we have users already we'll just add Filler Name, default otherwise wouldn't allow us to
    # validate later.
    User.all.each { |u| u.update!({ name: "Filler Name" }) }
  end

  def down
    remove_column :users, :name, :string
  end
end
