class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :employer_id
      t.integer :job_id
      t.decimal :amount, precision: 18, scale: 4
      t.string :stripe_card_token
      t.string :stripe_customer_id
      t.string :stripe_charge_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
