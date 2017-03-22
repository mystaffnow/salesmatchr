class CandidateJobActionsController < ApplicationController
  before_action :authenticate_candidate!, only: [:candidate_job_saved,
                                                 :candidate_job_viewed,
                                                 :candidate_matches,
                                                 :candidate_save_job
                                               ]
  # list of the jobs saved by candidate
  def candidate_job_saved
    # @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id, is_saved: true)
    @jobs = Job.joins(:candidate_job_actions)
               .where("candidate_job_actions.candidate_id=?
                      and candidate_job_actions.is_saved=true", current_candidate.id)
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed saved')
  end

  # List of the jobs which are viewed by candidate
  def candidate_job_viewed
    # @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id).order('created_at DESC')
    @jobs = Job.joins(:candidate_job_actions)
               .where("candidate_job_actions.candidate_id=?", current_candidate.id)
               .order('created_at DESC')
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed recently viewed jobs')
  end
  
  # List all jobs which are active and matched to the candidate
  # Candidate should not see inactive jobs in matched list, although they matched to it
  def candidate_matches
    @jobs = Job.where(":archetype_score >= archetype_low and
                       :archetype_score <= archetype_high and
                       jobs.is_active = TRUE",
                       archetype_score: current_candidate.archetype_score)

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed matches')
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
