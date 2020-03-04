class AddTrackableToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      # We don't want to track IP address, so we're not even adding these columns. Leaving this
      # for posterity since these are default Devise::Trackable columns whose accessor methods we
      # manually override in the User model and we want the history / note.
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip
    end
  end
end
