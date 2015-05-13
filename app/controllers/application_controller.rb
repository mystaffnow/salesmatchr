class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_candidate
  before_filter :check_employer
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def check_candidate
    if candidate_signed_in?
      if !current_candidate.can_proceed
        redirect_to candidates_archetype_path, notice: "Please complete the archetype form before proceeding"
      end
    end
  end
  def check_employer
    if employer_signed_in?
      if !current_employer.can_proceed
        redirect_to employers_account_path
      end
    end
  end
end
