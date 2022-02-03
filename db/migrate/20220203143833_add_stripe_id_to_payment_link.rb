class AddStripeIdToPaymentLink < ActiveRecord::Migration[7.1]
  def change
    add_column :payment_links, :stripe_id, :string
  end
end
