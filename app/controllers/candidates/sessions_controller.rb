class Candidates::SessionsController < Devise::SessionsController
  skip_before_filter :check_candidate, only: [:destroy]
  def after_sign_in_path_for(resource)
    '/my_jobs'
  end
end