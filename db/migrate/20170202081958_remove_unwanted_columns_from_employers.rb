class RemoveUnwantedColumnsFromEmployers < ActiveRecord::Migration
  def change
	  remove_column :employers, :website, :string
	  remove_column :employers, :ziggeo_token, :string
	  remove_column :employers, :zip, :string
	  remove_column :employers, :city, :string
	  remove_column :employers, :state_id, :integer
	  remove_column :employers, :description, :string
	  remove_column :employers, :avatar_file_name , :string
    remove_column :employers, :avatar_content_type, :string
    remove_column :employers, :avatar_file_size, :integer
    remove_column :employers, :avatar_updated_at, :datetime
  end
end
