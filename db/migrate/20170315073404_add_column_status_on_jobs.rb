class AddColumnStatusOnJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :status, :integer, default: 0 # job is active by default
  end
end
