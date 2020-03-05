class AddNameToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :name
    end

    # Since we have users already we'll just add Filler Name, default otherwise wouldn't allow us to
    # validate later.
    User.all.each { |u| u.update!({ name: "Filler Name" }) }
  end
end
