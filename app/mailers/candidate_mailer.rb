class CandidateMailer < ApplicationMailer
  default :from => 'donotreply@salesmatchr.com'
  def send_job_hire(email, job)
    @job = job
    mail( :to => email,
          :subject => 'You have been hired for a job on SalesMatchr' ) do |format|
      format.html { render layout: false }
    end
  end
end
