class RemoveColumnCardNumberFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :card_number
  end
end
