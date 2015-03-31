class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :position
      t.string :company
      t.string :description
      t.date :start_date
      t.date :end_date
      t.boolean :is_current
      t.boolean :is_sales
      t.integer :sales_type_id
      t.integer :candidate_id

      t.timestamps null: false
    end
  end
end
