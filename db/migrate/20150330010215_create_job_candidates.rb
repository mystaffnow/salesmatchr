class CreateJobCandidates < ActiveRecord::Migration
  def change
    create_table :job_candidates do |t|
      t.integer :candidate_id
      t.integer :job_id
      t.boolean :is_hired

      t.timestamps null: false
    end
  end
end
