class ChangeIsActiveOnJobs < ActiveRecord::Migration
  def self.up
    change_column :jobs, :is_active, :boolean, default: false
  end

  def self.down
    change_column :jobs, :is_active, :boolean, default: true
  end
end
