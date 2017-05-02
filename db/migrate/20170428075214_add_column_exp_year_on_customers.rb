class AddColumnExpYearOnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :exp_year, :integer
  end
end
