class AddColumnActivatedAtOnJobs < ActiveRecord::Migration
  def self.up
  	add_column :jobs, :activated_at, :datetime

  	Job.all.each do |job|
  		job.update_attribute(:activated_at, job.created_at)
  	end
  end

  def self.down
  	remove_column :jobs, :activated_at 
  end
end
