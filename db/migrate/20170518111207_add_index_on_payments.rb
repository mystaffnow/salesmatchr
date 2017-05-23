class AddIndexOnPayments < ActiveRecord::Migration
  def change
    add_index :payments, :employer_id
    add_index :payments, :job_id
  end
end
