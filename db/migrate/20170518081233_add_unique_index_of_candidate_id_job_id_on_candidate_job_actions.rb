class AddUniqueIndexOfCandidateIdJobIdOnCandidateJobActions < ActiveRecord::Migration
  def change
    add_index :candidate_job_actions, :candidate_id
    add_index :candidate_job_actions, :job_id
    add_index :candidate_job_actions, [:candidate_id, :job_id], unique: true
  end
end
