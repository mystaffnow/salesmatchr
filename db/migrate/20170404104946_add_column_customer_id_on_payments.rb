class AddColumnCustomerIdOnPayments < ActiveRecord::Migration
  def change
    add_column :payments, :customer_id, :integer
    add_index :payments, :customer_id
  end
end
