class CandidatesController < ApplicationController
  skip_before_filter :check_candidate, only: [:account, :update]
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
        format.html { redirect_to candidates_profile_path(current_candidate), notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:zip, :city, :state_id, :ziggeo_token, :education_level_id, :archetype_score, :experiences_attributes => [:position, :company, :start_date, :end_date, :description, :is_sales, :sales_type_id], educations_attributes: [:school, :education_level_id, :description] )
    end
end