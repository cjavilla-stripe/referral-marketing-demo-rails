class PaymentLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account!

  def create
    price = Stripe::Price.retrieve(params[:price])
    commission = 0.15 # Affiliates earn 15% of the payment
    commission_amount = price.unit_amount * commission

    payment_link = Stripe::PaymentLink.create(
      line_items: [{
        price: params[:price],
        quantity: 1
      }],
      transfer_data: {
        destination: current_user.stripe_account_id,
        amount: commission_amount.to_i,
      },
      allow_promotion_codes: true,
      automatic_tax: {
        enabled: true
      },
      billing_address_collection: 'auto',
      shipping_address_collection: {
        allowed_countries: ['US', 'CA', 'MX', 'IE', 'GB', 'AU', 'NZ', 'BE', 'FR', 'DE', 'NL', 'IT', 'ES', 'DK', 'NO', 'SE', 'FI', 'EE', 'LV', 'LT', 'PL', 'CZ', 'AT', 'CH', 'SK', 'SI', 'HR', 'BA', 'BG', 'RO', 'RS', 'ME', 'MK', 'GR', 'PT', 'HU', 'IS', 'LI', 'MT', 'CY', 'MC', 'SI', 'TR', 'BG', 'BY', 'UA', 'MD', 'RU', 'UA', 'RS', 'CZ', 'UA', 'LV', 'LT', 'PL', 'CZ', 'AT', 'CH', 'SK', 'SI', 'HR', 'BA', 'BG', 'RO', 'RS', 'ME', 'MK', 'GR', 'PT', 'HU', 'IS', 'LI', 'MT', 'CY', 'MC', 'SI', 'TR', 'BG', 'BY', 'UA', 'MD', 'RU', 'UA', 'RS', 'CZ', 'UA', 'LV', 'LT', 'PL', 'CZ', 'AT', 'CH', 'SK', 'SI', 'HR', 'BA', 'BG', 'RO', 'RS', 'ME', 'MK', 'GR', 'PT', 'HU', 'IS', 'LI', 'MT', 'CY', 'MC', 'SI', 'TR', 'BG', 'BY', 'UA', 'MD', 'RU', 'UA', 'RS', 'CZ', 'UA', 'LV', 'LT', 'PL', 'CZ', 'AT', 'CH', 'SK', 'SI', 'HR', 'BA', 'BG', 'RO', 'RS', 'ME', 'MK', 'GR', 'PT', 'HU', 'IS', 'LI', 'MT', 'CY', 'MC', 'SI', 'TR', 'BG', 'BY', 'UA', 'MD', 'RU'],
      },
    )

    @payment_link = current_user.payment_links.create!(
      url: payment_link.url,
      price: params[:price],
      stripe_id: payment_link.id
    )

    redirect_back fallback_location: product_path(params[:price])
  end
end
