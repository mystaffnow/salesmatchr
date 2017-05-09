class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  before_filter :check_candidate
  before_filter :check_employer
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :action_not_authorized

  # authorize user
  def pundit_user
    if candidate_signed_in?
      current_candidate
    else
      current_employer
    end
  end

  protected

  # strong parameters config for devise controllers, views
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # if archetype_score is nil, candidate should submit archetype form
  def check_candidate
    if candidate_signed_in?
      if !current_candidate.can_proceed
        redirect_to candidates_archetype_path
      end
    end
  end

  # zip, city, state, email, fullname, website, etc of employer is required
  def check_employer
    if employer_signed_in?
      if !current_employer.can_proceed
        redirect_to employers_account_path, alert: 'Complete your profile details before continue.'
      end
    end
  end

  private

  # when action is unauthorized, it goes to url saved on referrer or root url and
  # alert message will displays
  def action_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
