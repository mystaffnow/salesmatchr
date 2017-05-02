class AddColumnExpMonthOnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :exp_month, :integer
  end
end
