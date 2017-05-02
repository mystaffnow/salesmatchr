class AddColumnIsSelectedToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :is_selected, :boolean, default: false
  end
end
