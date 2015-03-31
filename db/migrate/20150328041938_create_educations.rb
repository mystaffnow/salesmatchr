class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :school
      t.integer :education_level_id
      t.string :description
      t.date :start_date
      t.date :end_date
      t.integer :candidate_id

      t.timestamps null: false
    end
  end
end
