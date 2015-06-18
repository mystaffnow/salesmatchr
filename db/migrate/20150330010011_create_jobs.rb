class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :employer_id
      t.integer :salary_low
      t.integer :salary_high
      t.string :zip
      t.boolean :is_remote
      t.string :title
      t.text :description
      t.boolean :is_active, default: false
      t.integer :view_count
      t.integer :state_id
      t.string :city
      t.integer :archetype_low
      t.integer :archetype_high
      t.integer :job_function_id
      t.float :latitude
      t.float :longitude
      t.string :stripe_customer_token
      t.integer :experience_years

      t.timestamps null: false
    end
  end
end
