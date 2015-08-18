class Employers::SessionsController < Devise::SessionsController
  skip_before_filter :check_employer, only: [:destroy]
  def after_sign_in_path_for(resource)
    '/employer_jobs'
  end
end