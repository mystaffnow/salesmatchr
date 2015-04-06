class CreateJobFunctions < ActiveRecord::Migration
  def change
    create_table :job_functions do |t|
      t.string :name
      t.integer :low
      t.integer :high

      t.timestamps null: false
    end
  end
end
