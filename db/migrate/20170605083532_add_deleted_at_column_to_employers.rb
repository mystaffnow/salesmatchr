class AddDeletedAtColumnToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :deleted_at, :datetime
  end
end
