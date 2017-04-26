class RemoveColumnStripeCustomerIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :stripe_customer_id, :integer
  end
end
