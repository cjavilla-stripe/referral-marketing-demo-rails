class ApplicationController < ActionController::Base
  def require_account!
    return if !current_user
    if !current_user.stripe_account_id.blank? && !current_user.charges_enabled
      account_link = Stripe::AccountLink.create(
        account: current_user.stripe_account_id,
        type: 'account_onboarding',
        refresh_url: products_url,
        return_url: products_url
      )
      redirect_to account_link.url, allow_other_host: true, status: :see_other
    end
  end
end
