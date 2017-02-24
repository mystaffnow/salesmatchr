class SendEmailJob < ActiveJob::Base
  include SuckerPunch::Job

  def perform(candidate, job)
	  CandidateMailer.send_job_match(candidate, job).deliver_now
  end
end
