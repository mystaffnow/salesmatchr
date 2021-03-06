class CandidateMailer < ApplicationMailer
  default :from => 'donotreply@salesmatchr.com'

  def send_job_hire(email, job)
    @job = job
    template_id(ENV['SENDGRID_TEMPLATE_ID'])
    mail( :to => email,
          :subject => 'You have been accepted for a job on SalesMatchr' ) do |format|
      format.html { render layout: false }
    end
  end

  # ToDo: remove this later
  # def send_job_intro(email, job)
  #   @job = job
  #   mail( :to => email,
  #         :subject => 'Someone is interested in you on SalesMatchr' ) do |format|
  #     format.html { render layout: false }
  #   end
  # end

  def send_job_match(candidate, job)
    @candidate = candidate
    @job = job
    template_id(ENV['SENDGRID_TEMPLATE_ID'])
    mail(to: candidate.email, subject: 'New job match your profile') do |format|
      format.html { render layout: false }
    end
  end
end
