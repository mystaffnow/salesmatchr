class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :city
      t.integer :state_id
      t.string :zip
      t.integer :education_level_id
      t.integer :archetype_score
      t.string :ziggeo_token

      t.timestamps null: false
    end
  end
end
