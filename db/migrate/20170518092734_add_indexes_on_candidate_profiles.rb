class AddIndexesOnCandidateProfiles < ActiveRecord::Migration
  def change
    # candidate has one profile
    add_index :candidate_profiles, :candidate_id, unique: true
    add_index :candidate_profiles, :state_id
    add_index :candidate_profiles, :education_level_id
  end
end
