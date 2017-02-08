class CandidateJobActionsController < ApplicationController
  before_action :authenticate_candidate!, only: [:candidate_job_saved,
                                                 :candidate_job_viewed,
                                                 :candidate_matches]
  def candidate_job_saved
    @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id, is_saved: true)

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed saved')
  end

  def candidate_job_viewed
    @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id).order('created_at DESC')

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed recently viewed jobs')
  end
  
  def candidate_matches
    @jobs = Job.where("archetype_low <= ? and archetype_high >= ? and jobs.is_active = TRUE", current_candidate.archetype_score, current_candidate.archetype_score)

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'viewed matches')
  end
end
