class AddColumnIsActiveMatchSubscriptionToCandidateProfiles < ActiveRecord::Migration
  def change
    add_column :candidate_profiles, :is_active_match_subscription, :boolean, :default => true
  end
end
