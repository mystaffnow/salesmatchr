namespace :schedular do
	desc "Job is active till 30 days, after 30days it should automatically inactive"
	task :inactive_expire_job => :environment do
		
		Job.where("? > activated_at", 30.days.ago).each do |job|
			job.update(status: Job.statuses["disable"])
		end
	end
end
