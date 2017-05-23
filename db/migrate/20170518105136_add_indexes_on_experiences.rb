class AddIndexesOnExperiences < ActiveRecord::Migration
  def change
    add_index :experiences, :sales_type_id
    add_index :experiences, :candidate_id
  end
end
