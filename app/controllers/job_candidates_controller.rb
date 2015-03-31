class JobCandidatesController < ApplicationController
  before_action :set_job_candidate, only: [:show, :edit, :update, :destroy]
  def index
    @job_candidates = JobCandidate.where(:candidate_id => current_candidate.id)
  end
  def apply
    @job = Job.find(params.permit(:id)[:id])
    JobCandidate.create job_id: @job.id, candidate_id: current_candidate.id
    redirect_to ''
  end
  def update
    respond_to do |format|
      if @job_candidate.update(job_candidate_params)
        format.html { redirect_to employer_jobs_path, notice: 'Successfully hired, an email was sent to the candidate.' }
      end
    end
  end
  private
    def set_job_candidate
      @job_candidate = JobCandidate.find(params[:id])
    end
    def job_candidate_params
      params.require(:job_candidate).permit(:is_hired)
    end
end