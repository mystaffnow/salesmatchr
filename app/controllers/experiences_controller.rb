class ExperiencesController < ApplicationController
  before_action :set_experience, only: [:destroy]
  before_action :authenticate_candidate!, only: :destroy

  # DELETE /experiences/1
  # DELETE /experiences/1.json
  def destroy
    authorize @experience
    @experience.destroy
    respond_to do |format|
      format.html { redirect_to candidates_profile_path(current_candidate.id),
                    notice: 'Experience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_experience
    @experience = Experience.find(params[:id])
  end
end
