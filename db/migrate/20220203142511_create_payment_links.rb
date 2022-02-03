class CreatePaymentLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_links do |t|
      t.string :url
      t.string :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
