class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.integer :state_id
      t.string :zip
      t.integer :education_level_id
      t.integer :archetype_score
      t.string :ziggeo_token
      t.string :uid
      t.string :provider
      t.boolean :is_incognito
      t.integer :year_experience_id
      t.string :linkedin_picture_url

      t.timestamps null: false
    end
  end
end
