class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :company
      t.integer :state_id
      t.string :city
      t.string :zip
      t.string :description
      t.string :website
      t.string :ziggeo_token

      t.timestamps null: false
    end
  end
end
