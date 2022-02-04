class PaymentLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account!

  def create
    # Retrieve the current price
    price = Stripe::Price.retrieve(params[:price])

    # Calculate the commission for the affiliate
    commission = 0.15
    affiliate_commission = price.unit_amount * commission # 7000 * 0.15 = 1050

    # Create a new Stripe Payment Link
    payment_link = Stripe::PaymentLink.create(
      line_items: [{
        price: price.id,
        quantity: 1
      }],
      automatic_tax: {
        enabled: true,
      },
      allow_promotion_codes: true,
      billing_address_collection: 'auto',
      shipping_address_collection: {
        allowed_countries: ['US', 'MX', 'CA'],
      },
      transfer_data: {
        destination: current_user.stripe_account_id,
        amount: affiliate_commission.to_i,
      }
    )

    # Store the PaymentLink in the database associated with the affiliate
    @payment_link = current_user.payment_links.create(
      url: payment_link.url,
      stripe_id: payment_link.id,
      stripe_price_id: price.id,
    )

    redirect_back fallback_location: products_path
  end
end
