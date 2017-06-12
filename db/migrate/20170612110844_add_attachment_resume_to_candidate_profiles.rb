class AddAttachmentResumeToCandidateProfiles < ActiveRecord::Migration
  def self.up
    change_table :candidate_profiles do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :candidate_profiles, :resume
  end
end
