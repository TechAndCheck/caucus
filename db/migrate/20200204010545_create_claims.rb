class CreateClaims < ActiveRecord::Migration[6.0]
  def change
    create_table :claims do |t|
      t.string :statement
      t.string :speaker_name
      t.string :speaker_title
      t.date :date
      t.string :location
      t.string :publisher_name
      t.uuid :fact_string_id
      t.timestamps
    end
  end
end
