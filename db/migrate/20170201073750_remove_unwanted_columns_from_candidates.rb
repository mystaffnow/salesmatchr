class RemoveUnwantedColumnsFromCandidates < ActiveRecord::Migration
  def change
  	remove_column :candidates, :city, :string
    remove_column :candidates, :state_id, :integer
    remove_column :candidates, :zip, :string
    remove_column :candidates, :education_level_id, :integer
    remove_column :candidates, :ziggeo_token, :string
    remove_column :candidates, :uid, :string
    remove_column :candidates, :provider, :string
    remove_column :candidates, :is_incognito, :boolean
    remove_column :candidates, :linkedin_picture_url, :string
    remove_column :candidates, :avatar_file_name , :string
    remove_column :candidates, :avatar_content_type, :string
    remove_column :candidates, :avatar_file_size, :integer
    remove_column :candidates, :avatar_updated_at, :datetime
  end
end
