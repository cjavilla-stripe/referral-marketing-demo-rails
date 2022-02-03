class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Event.construct_from(
        JSON.parse(payload, symbolize_names: true)
      )
    rescue JSON::ParserError => e
      # Invalid payload
      puts "⚠️  Webhook error while parsing basic request. #{e.message})"
      status 400
      return
    end

    if event.type == 'account.updated'
      account = event.data.object
      user = User.find_by(stripe_account_id: account.id)
      user.update(charges_enabled: account.charges_enabled)
    elsif event.type == 'checkout.session.completed' || event.type == 'checkout.session.async_payment_succeeded'
      checkout_session = event.data.object
      if checkout_session.payment_status == 'paid'
        puts "🎉Fulfill order!"
      end
    end
  end
end
