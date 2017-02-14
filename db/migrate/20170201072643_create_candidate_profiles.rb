class CreateCandidateProfiles < ActiveRecord::Migration
  def self.up
    create_table :candidate_profiles do |t|
    	t.integer :candidate_id
  		t.string :city
  	  t.integer :state_id
  	  t.string :zip
  	  t.integer :education_level_id
  	  t.string :ziggeo_token
  	  t.boolean :is_incognito
  	  t.string :linkedin_picture_url
  	  t.attachment :avatar

      t.timestamps null: false
    end

    Candidate.all.each do |c|
      cp = CandidateProfile.new(
        candidate_id: c.id,
        city: c.city,
        state_id: c.state_id,
        zip: c.zip,
        education_level_id: c.education_level_id,
        ziggeo_token: c.ziggeo_token,
        is_incognito: c.is_incognito,
        linkedin_picture_url: c.linkedin_picture_url,
        avatar: c.avatar
      )
      cp.save(validate: false)
    end
  end

  def self.down
    CandidateProfile.all.each do |cp|
      cp.candidate.update(
                          :city => cp.city,
                          :state_id => cp.state_id,
                          :zip => cp.zip,
                          :education_level_id => cp.education_level_id,
                          :ziggeo_token => cp.ziggeo_token,
                          :is_incognito => cp.is_incognito,
                          :linkedin_picture_url => cp.linkedin_picture_url,
                          avatar: cp.avatar)
    end 
    drop_table :candidate_profiles
  end
end
