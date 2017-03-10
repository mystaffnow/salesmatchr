class CandidatesController < ApplicationController
  skip_before_filter :check_candidate, only: [:archetype, :update_archetype, :update, :incognito]
  before_action :authenticate_candidate!, only: [:archetype, :account, :update,
                                                 :update_archetype, :archetype_result,
                                                 :incognito]
  # submit archetype
  # only signed_in candidate access this
  def archetype

  end

  # view profile
  # anyone can access
  def profile
    if params[:id]
      @candidate = Candidate.find(params[:id])
      @profile = @candidate.candidate_profile
    elsif current_cadidate
      @candidate = current_candidate
      @profile = current_candidate.candidate_profile
    end
  end

  # submit profile info
  # only signed_in candidate access this
  def account
    current_candidate.build_candidate_profile if !current_candidate.candidate_profile
  end

  # update candidate, profile, education, work experiences.
  # only signed_in candidate access this
  def update
    respond_to do |format|
      if current_candidate.update(candidate_params)
        current_candidate.save
        format.html { redirect_to candidates_profile_path(current_candidate), notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end

  # update archetype
  # only signed_in candidate access this
  def update_archetype
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'updated archetype')

    respond_to do |format|
      if current_candidate.update(candidate_params)
        current_candidate.archetype_score = CandidateQuestionAnswer.joins(:answer).where("candidate_question_answers.candidate_id = ?",current_candidate.id).sum :"answers.score"
        current_candidate.save
        format.html { redirect_to candidates_archetype_result_path }
      else
        format.html { render :account }
      end
    end
  end

  # view archetype result and submit form to complete profile
  # only signed_in candidate access this
  def archetype_result

  end

  #should make a put but tired
  # Toggle incognito
  # only signed_in candidate access this
  def incognito
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'incognito toggle')

    profile = current_candidate.candidate_profile
    profile.is_incognito = params[:is_incognito]
    profile.save
    render json: 'created'
  end

  # subscribe and unsubscribe to job match alert
  # only signed in candidate access this
  def subscription
    @profile = current_candidate.candidate_profile
    @profile.toggle!(:is_active_match_subscription)

    respond_to do |format|
      format.js {render layout: false}
    end
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:year_experience_id, :archetype_score, candidate_profile_attributes: [:id, :avatar, :is_incognito, 
                                                            :zip, :city, :state_id, 
                                                            :ziggeo_token, :education_level_id], 
                                        :experiences_attributes => [:id, :position, :company,
                                         :start_date, :end_date, :description, :is_sales,
                                          :sales_type_id, :is_current, :_destroy], educations_attributes: [:id,
                                           :college_id, :college_other, :education_level_id,
                                            :description, :_destroy], candidate_question_answers_attributes: [:question_id, 
                                              :id, :answer_id] )
    end
end