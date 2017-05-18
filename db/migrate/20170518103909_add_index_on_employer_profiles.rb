class AddIndexOnEmployerProfiles < ActiveRecord::Migration
  def change
    # employer has one profile
    add_index :employer_profiles, :employer_id, unique: true
    add_index :employer_profiles, :state_id
  end
end
