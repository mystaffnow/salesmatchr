class JobCandidatesController < ApplicationController
  before_action :authenticate_candidate!, only: [:index, :apply, :receipt, :withdraw]
  before_action :authenticate_employer!, only: [:accept_candidate, :remove_candidate, :shortlist_candidate]
  before_action :set_job_candidate, only: [:receipt, :withdraw, :accept_candidate]
  before_action :require_candidate_profile, only: [:index, :apply]

  # List all candiadte's job based on JobCandidate rec of current_candidate
  def index
    @job_candidates = JobCandidate.where(:candidate_id => current_candidate.id)
  end

  # Only candidate can apply on Job
  def apply
    @job = Job.find(params.permit(:id)[:id])
    job_candidate = JobCandidate.create job_id: @job.id, candidate_id: current_candidate.id
    job_candidate.submitted!

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+job_candidate.candidate.email, 'applied to job')

    EmployerMailer.send_job_application(@job.employer.email, @job).deliver
    redirect_to job_receipt_path(job_candidate)
  end

  # url: job_receipt/:id
  # Only candidate can access this page
  def receipt
    authorize @job_candidate
    @job = @job_candidate.job
  end

  # Candidate can withdraw job application
  # signed_in candidate is required
  def withdraw
    authorize @job_candidate
    @job_candidate.withdrawn!
    EmployerMailer.send_job_withdrawn(@job_candidate.job.employer.email, @job_candidate.job).deliver
    redirect_to job_candidates_path, notice: 'Successfully withdrawn.'
  end

  # signed_in employer is required
  # employer can accept candidate's application
  def accept_candidate
    authorize(@job_candidate)
    @job_candidate.accepted!
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('employer-'+current_employer.email, 'accepted candidate')
    CandidateMailer.send_job_hire(@job_candidate.candidate.email, @job_candidate.job).deliver
    redirect_to employer_jobs_path, notice: 'Successfully accepted, an email was sent to the candidate.'
  end

  # This action is used by employer to remove this candidate from the job in which this candidate had applied already.
  def remove_candidate
    job_candidate = JobCandidate.where(:job_id => params[:job_id], :candidate_id => params[:candidate_id]).first
    authorize(job_candidate)
    job_candidate.status = JobCandidate.statuses[:deleted]
    job_candidate.save

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('employer-'+current_employer.email, 'removed candidate from job')

    redirect_to employer_show_path(params[:job_id]), notice: 'Candidate removed'
  end

  # This action is used by employer to shortlist candidate who had applied to employer's job
  def shortlist_candidate
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('employer-'+current_employer.email, 'shortlisted candidate')

    job_candidate = JobCandidate.where(:job_id => params[:job_id], :candidate_id => params[:candidate_id]).first
    authorize(job_candidate)
    job_candidate.status = JobCandidate.statuses[:shortlist]
    job_candidate.save

    redirect_to employer_show_path(params[:job_id]), notice: 'Candidate shortlisted'
  end 

  private

  def set_job_candidate
    @job_candidate = JobCandidate.find(params[:id])
  end

  def job_candidate_params
    params.require(:job_candidate).permit(:is_hired, :status, :job_id, :candidate_id)
  end

  # candidate should save his profile info before applying any job of employer because employer can view candidate's profile.
  def require_candidate_profile
    unless current_candidate.candidate_profile.present?
      redirect_to candidates_account_path, notice: 'Complete your profile information'
    end
  end
end