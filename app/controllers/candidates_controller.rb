class CandidatesController < ApplicationController
  skip_before_filter :check_candidate, only: [:archetype, :update_archetype, :update, :incognito]
  def archetype

  end
  def profile
    if params[:id]
      @candidate = Candidate.find(params.permit(:id)[:id])
    elsif current_cadidate
      @candidate = current_candidate
    end
  end
  def account
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
  #should make a put but tired
  def incognito

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('candidate-'+current_candidate.email, 'incognito toggle')

    current_candidate.is_incognito = params[:is_incognito]
    current_candidate.save
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:year_experience_id, :avatar, :is_incognito, :zip, :city, :state_id, :ziggeo_token, :education_level_id, :archetype_score, :experiences_attributes => [:id, :position, :company, :start_date, :end_date, :description, :is_sales, :sales_type_id, :is_current], educations_attributes: [:id, :college_id, :college_other, :education_level_id, :description], candidate_question_answers_attributes: [:question_id, :id, :answer_id] )
    end
end