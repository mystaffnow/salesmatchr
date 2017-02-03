class CreateEmployerProfiles < ActiveRecord::Migration
  def change
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
  end
end
