class RemoveUnwantedColumnsFromEmployers < ActiveRecord::Migration
  def change
	  remove_column :employers, :website
	  remove_column :employers, :ziggeo_token
	  remove_column :employers, :zip
	  remove_column :employers, :city
	  remove_column :employers, :state_id
	  remove_column :employers, :description
	  remove_attachment :employers, :avatar
  end
end
