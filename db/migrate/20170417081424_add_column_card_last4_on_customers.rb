class AddColumnCardLast4OnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :last4, :integer
  end
end
