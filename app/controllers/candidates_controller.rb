class CandidatesController < ApplicationController
  skip_before_filter :check_candidate, only: [:archetype, :update_archetype, :update, :incognito]
  def archetype

  end
  def profile
    if params[:id]
      @candidate = Candidate.find(params.permit(:id)[:id])
      @profile = @candidate.candidate_profile
    elsif current_cadidate
      @candidate = current_candidate
      @profile = current_candidate.candidate_profile
    end
  end
  def account
    current_candidate.build_candidate_profile if !current_candidate.candidate_profile
  end
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
  def archetype_result

  end
  #should make a put but tired
  def incognito
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'incognito toggle')

    profile = current_candidate.candidate_profile

    profile.is_incognito = params[:is_incognito]
    profile.save
    render json: 'created'
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(candidate_profile_attributes: [:id, :avatar, :is_incognito, 
                                                            :zip, :city, :state_id, 
                                                            :ziggeo_token, :education_level_id], 
                                        :experiences_attributes => [:id, :position, :company,
                                         :start_date, :end_date, :description, :is_sales,
                                          :sales_type_id, :is_current], educations_attributes: [:id,
                                           :college_id, :college_other, :education_level_id,
                                            :description], candidate_question_answers_attributes: [:question_id, 
                                              :id, :answer_id] )
    end
end