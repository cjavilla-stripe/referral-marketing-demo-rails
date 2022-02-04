class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account!

  def index
    @prices = Stripe::Price.list(
      type: 'one_time',
      lookup_keys: ['furni-chair', 'furni-sofa', 'furni-retro-chair', 'furni-stool'],
      expand: ['data.product'],
    )
  end

  def show
    @price = Stripe::Price.retrieve(
      id: params[:id],
      expand: ['product']
    )
    @payment_link = current_user.payment_links.find_by(stripe_price_id: @price.id)
  end
end
