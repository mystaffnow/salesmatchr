class AddColumnCardNumberOnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :card_number, :string
  end
end
