class AddIndexesOnEducations < ActiveRecord::Migration
  def change
    add_index :educations, :college_id
    add_index :educations, :education_level_id
    add_index :educations, :candidate_id
  end
end
