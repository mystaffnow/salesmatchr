class CreateCandidateProfiles < ActiveRecord::Migration
  def change
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
  end
end
