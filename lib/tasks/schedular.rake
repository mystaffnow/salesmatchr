namespace :schedular do
	desc "Job is active till 30 days, after 30days it should automatically inactive"
	task :inactive_expire_job => :environment do
		p "Scheduler run at - #{Time.now}"
		Job.where("? > activated_at and status=?", 30.days.ago, Job.statuses['enable']).each do |job|
			job.update_attribute(:status, Job.statuses["expired"])
		end
	end
end
