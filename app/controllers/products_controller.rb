class ProductsController < ApplicationController
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
  end
end