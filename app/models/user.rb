class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  before_validation :maybe_create_account, on: :create
  def maybe_create_account
    return if stripe_account_id.present?

    account = Stripe::Account.create(
      type: 'express',
      country: 'US',
      email: email,
      business_type: 'individual',
      individual: {
        address: {
          line1: 'address_full_match',
          city: 'San Francisco',
          state: 'CA',
          postal_code: '94103',
          country: 'US'
        },
        first_name: 'Jenny',
        last_name: 'Rosen',
        email: 'cjavilla+201@stripe.com',
        id_number: '000000000',

        dob: {
          day: 1,
          month: 1,
          year: 1901
        }
      },
      business_profile: {
        mcc: '7311',
        url: 'http://cjavilla.com',
      },
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      }
    )

    self.update(stripe_account_id: account.id)
  end
end
