class AddIndexesOnJobs < ActiveRecord::Migration
  def change
    add_index :jobs, :employer_id
    add_index :jobs, :job_function_id
    add_index :jobs, :state_id
  end
end
