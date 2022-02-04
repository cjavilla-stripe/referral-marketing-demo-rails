class CreatePaymentLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_links do |t|
      t.string :stripe_id
      t.string :stripe_price_id
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
