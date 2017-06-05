class Employers::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    super
    if resource.save
      tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
      tracker.people.set('employer-'+current_employer.email, {
                                                                '$email'            => current_employer.email,
                                                                '$first_name'       => current_employer.company
                                                             });
      tracker.track('employer-'+current_employer.email, 'employer sign up')
    end
  end

  def destroy
    resource.archive
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) } 
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
