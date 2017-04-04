class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :employer_id
      t.string :stripe_card_token
      t.string :stripe_customer_id

      t.timestamps null: false
    end
    add_index :customers, :employer_id
  end
end
