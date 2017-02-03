class RemoveUnwantedColumnsFromCandidates < ActiveRecord::Migration
  def change
  	remove_column :candidates, :city
    remove_column :candidates, :state_id
    remove_column :candidates, :zip
    remove_column :candidates, :education_level_id
    remove_column :candidates, :ziggeo_token
    remove_column :candidates, :uid
    remove_column :candidates, :provider
    remove_column :candidates, :is_incognito
    remove_column :candidates, :linkedin_picture_url
    remove_attachment :candidates, :avatar
  end
end
