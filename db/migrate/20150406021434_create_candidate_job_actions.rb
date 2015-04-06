class CreateCandidateJobActions < ActiveRecord::Migration
  def change
    create_table :candidate_job_actions do |t|
      t.integer :candidate_id
      t.integer :job_id
      t.boolean :is_saved

      t.timestamps null: false
    end
  end
end
