class CreateEmployerProfiles < ActiveRecord::Migration
  def self.up
    create_table :employer_profiles do |t|
    	t.integer :employer_id
    	t.string :website
		  t.string :ziggeo_token
		  t.string :zip
		  t.string :city
		  t.integer :state_id
		  t.string :description
		  t.attachment :avatar

      t.timestamps null: false
    end
    Employer.all.each do |e|
      ep = EmployerProfile.new(
        employer_id: e.id,
        website: e.website,
        ziggeo_token: e.ziggeo_token,
        zip: e.zip,
        city: e.city,
        state_id: e.state_id,
        description: e.description,
        avatar: e.avatar
      )
      ep.save(validate: false)
    end
  end

  def self.down
    EmployerProfile.all.each do |ep|
      ep.employer.update(:website => ep.website,
                          :ziggeo_token => ep.ziggeo_token,
                          :zip => ep.zip,
                          :city => ep.city,
                          :state_id => ep.state_id,
                          :description => ep.description,
                          avatar: ep.avatar)
    end 
    drop_table :employer_profiles
  end
end
