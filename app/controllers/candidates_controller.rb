class CandidatesController < ApplicationController
  skip_before_filter :check_candidate, only: [:account, :update, :incognito]
  def profile
    if params[:id]
      @candidate = Candidate.find(params.permit(:id)[:id])
    elsif current_cadidate
      @candidate = current_candidate
    end
  end
  def account
  end
  def update
    respond_to do |format|
      if current_candidate.update(candidate_params)
        current_candidate.archetype_score = CandidateQuestionAnswer.joins(:answer).where("candidate_question_answers.candidate_id = ?",1).sum :"answers.score"
        current_candidate.save
        format.html { redirect_to candidates_profile_path(current_candidate), notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end
  #should make a put but tired
  def incognito
    current_candidate.is_incognito = params[:is_incognito]
    current_candidate.save
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:avatar, :is_incognito, :zip, :city, :state_id, :ziggeo_token, :education_level_id, :archetype_score, :experiences_attributes => [:id, :position, :company, :start_date, :end_date, :description, :is_sales, :sales_type_id], educations_attributes: [:id, :school, :education_level_id, :description], candidate_question_answers_attributes: [:question_id, :id, :answer_id] )
    end
end