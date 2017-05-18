class AddIndexesOnCandidates < ActiveRecord::Migration
  def change
    add_index :candidates, :year_experience_id
  end
end
