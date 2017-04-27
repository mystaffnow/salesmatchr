class AddCardHolderNameOnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :card_holder_name, :string
  end
end
