class AddChargesEnabledToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :charges_enabled, :boolean, default: false
  end
end
