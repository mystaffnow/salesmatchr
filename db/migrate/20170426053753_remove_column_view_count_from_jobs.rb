class RemoveColumnViewCountFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :view_count, :integer
  end
end
