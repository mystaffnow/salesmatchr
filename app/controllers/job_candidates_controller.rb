class JobCandidatesController < ApplicationController
  before_action :set_job_candidate, only: [:show, :edit, :update, :destroy]
  def index
    @job_candidates = JobCandidate.where(:candidate_id => current_candidate.id)
  end
  def apply
    @job = Job.find(params.permit(:id)[:id])
    job_candidate = JobCandidate.create job_id: @job.id, candidate_id: current_candidate.id
    job_candidate.submitted!

    EmployerMailer.send_job_application(@job.employer.email, @job).deliver
    redirect_to ''
  end
  def update
    respond_to do |format|
      if @job_candidate.update(job_candidate_params)
        #super should fix
        if current_candidate
          EmployerMailer.send_job_withdrawn(@job_candidate.job.employer.email, @job_candidate.job).deliver
          format.html { redirect_to job_candidates_path, notice: 'Successfully withdrawn.' }
        elsif current_employer
          CandidateMailer.send_job_hire(@job_candidate.candidate.email, @job_candidate.job).deliver
          format.html { redirect_to employer_jobs_path, notice: 'Successfully hired, an email was sent to the candidate.' }
        end
      end
    end
  end
  def remove_candidate
    job_candidate = JobCandidate.where(:job_id => params[:job_id], :candidate_id => params[:candidate_id]).first
    job_candidate.status = JobCandidate.statuses[:deleted]
    job_candidate.save
    redirect_to employer_show_path(params[:job_id]), notice: 'Candidate removed'
  end
  def shortlist_candidate
    job_candidate = JobCandidate.where(:job_id => params[:job_id], :candidate_id => params[:candidate_id]).first
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
end