class EmployerMailer < ApplicationMailer
  default :from => 'donotreply@salesmatchr.com'

  def send_job_application(email, job)
    @job = job
    template_id(ENV['SENDGRID_TEMPLATE_ID'])
    mail( :to => email,
          :subject => 'Someone has applied to your job at SalesMatchr!' ) do |format|
      format.html { render layout: false }
    end
  end
  def send_job_withdrawn(email, job)
    @job = job
    template_id(ENV['SENDGRID_TEMPLATE_ID'])
    mail( :to => email,
          :subject => 'Someone has withdrawn an application for your job at SalesMatchr' ) do |format|
      format.html { render layout: false }
    end
  end
end
