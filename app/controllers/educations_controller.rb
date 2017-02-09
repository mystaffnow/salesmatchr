class EducationsController < ApplicationController
  before_action :set_education, only: [:destroy]
  before_action :authenticate_candidate!

  # DELETE /educations/1
  # DELETE /educations/1.json
  def destroy
    authorize @education
    @education.destroy
    respond_to do |format|
      format.html { redirect_to candidates_profile_path(current_candidate.id), notice: 'Education was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_education
    @education = Education.find(params[:id])
  end
end
