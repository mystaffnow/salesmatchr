class RemoveColumnStripeTokenFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :stripe_token, :string
  end
end
