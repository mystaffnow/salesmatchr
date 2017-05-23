class AddIndexesOnJobCandidates < ActiveRecord::Migration
  def change
    add_index :job_candidates, :candidate_id
    add_index :job_candidates, :job_id
    add_index :job_candidates, [:candidate_id, :job_id], unique: true
  end
end
