class RemoveColumnStripeCardTokenFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :stripe_card_token, :string
  end
end
