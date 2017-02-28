class EmployersController < ApplicationController
  skip_before_filter :check_employer, only: [:account, :update]
  before_action :authenticate_employer!, only: [:profile, :update, :account]
  before_action :set_profile, only: [:profile, :account, :update]

  # view employer's profile, signed in employer can access this
  def profile
    authorize @profile
  end

  # submit account information, signed in employer can access this
  def account
    authorize @profile
  end

  # update profile information of employer, signed in employer can access this
  def update
    authorize @profile
    respond_to do |format|
      if @profile.update(employer_params)
        format.html { redirect_to employers_profile_path, notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end

  # Get employer profile publicly, signed in employer or candidate can access this
  def public
    @employer = Employer.find(params[:id])
    @profile = @employer.try(:employer_profile)
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def employer_params
    params.require(:employer_profile).permit(:website, :ziggeo_token, :avatar, :zip, :city, :state_id, :description)
  end

  def set_profile
    @profile = EmployerProfile.find_or_initialize_by(employer_id: current_employer.id)
  end
end