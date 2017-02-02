class EmployersController < ApplicationController
  skip_before_filter :check_employer, only: [:account, :update]
  before_action :set_profile, only: [:profile, :account, :update]
  def profile

  end
  def account
  end
  def public
    @employer = Employer.find(params[:id])
    @profile = @employer.try(:employer_profile)
  end
  def update
    respond_to do |format|
      if @profile.update(employer_params)
        format.html { redirect_to employers_profile_path, notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def employer_params
    params.require(:employer_profile).permit(:website, :email, :ziggeo_token, :avatar, :zip, :city, :state_id, :name, :description, :company)
  end

  def set_profile
    @profile = EmployerProfile.find_or_initialize_by(employer_id: current_employer.id)
  end
end