class Candidates::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    # You need to implement the method below in your model (e.g. app/models/user.rb)

    @candidate = Candidate.from_omniauth(request.env["omniauth.auth"])


    if @candidate.persisted?
      flash.notice = "Signed in!"
      if @candidate.flash_notice
        flash.notice = @candidate.flash_notice
      end
      sign_in_and_redirect @candidate, notice: "Signed in!"
    else
      session["devise.candidate_attributes"] = @candidate.attributes
      redirect_to new_candidate_registration_url
    end
  end
end

