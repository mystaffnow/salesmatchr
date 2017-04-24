class CandidateJobActionsController < ApplicationController
  before_action :authenticate_candidate!, only: [:candidate_job_saved,
                                                 :candidate_job_viewed,
                                                 :candidate_matches,
                                                 :candidate_save_job]
  # list of the jobs saved by candidate
  def candidate_job_saved
    @jobs = Job.job_saved_list(current_candidate).page(params[:page])
    tracker = Mixpanel::Tracker.new(ENV['NT_MIXPANEL_TOKEN'])
    tracker.track('candidate-' + current_candidate.email, 'viewed saved')
  end

  # List of the jobs which are viewed by candidate
  def candidate_job_viewed
    @jobs = Job.job_viewed_list(current_candidate).page(params[:page])
    tracker = Mixpanel::Tracker.new(ENV['NT_MIXPANEL_TOKEN'])
    tracker.track('candidate-' + current_candidate.email, 'viewed recently viewed jobs')
  end

  # List all jobs which are active and matched to the candidate
  # Candidate should not see inactive jobs in matched list, although they matched to it
  def candidate_matches
    @jobs = Job.job_matched_list(current_candidate).page(params[:page])
    tracker = Mixpanel::Tracker.new(ENV['NT_MIXPANEL_TOKEN'])
    tracker.track('candidate-' + current_candidate.email, 'viewed matches')
  end

  # save the job
  def candidate_save_job
    @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id,
                                                     job_id: params[:job_id])
                                              .first_or_initialize
    authorize @candidate_job_action
    @candidate_job_action.is_saved = true
    @candidate_job_action.save
    redirect_to candidate_matches_path, notice: 'You have saved the job.'
  end
end
