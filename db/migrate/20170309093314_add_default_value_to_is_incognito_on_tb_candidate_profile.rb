class AddDefaultValueToIsIncognitoOnTbCandidateProfile < ActiveRecord::Migration
  def change
  	change_column :candidate_profiles, :is_incognito, :boolean, :default => true
  end
end
