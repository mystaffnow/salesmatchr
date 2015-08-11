class Employers::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    super
    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.people.set('employer-'+current_employer.email, {
                                                               '$email'            => current_employer.email,
                                                               '$first_name'       => current_employer.company
                                                           });
    tracker.track('employer-'+current_employer.email, 'employer sign up')
  end

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :company,
               :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :company,
               :email, :password, :password_confirmation, :current_password)
    end
  end
end