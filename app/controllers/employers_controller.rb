class EmployersController < ApplicationController
  def profile

  end
  def account

  end
  def update
    respond_to do |format|
      if current_employer.update(employer_params)
        format.html { redirect_to employers_profile_path, notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def employer_params
    params.require(:employer).permit(:website, :email, :ziggeo_token, :avatar, :zip, :city, :state_id, :name, :description, :company)
  end
end