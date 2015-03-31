class Candidates::SessionsController < Devise::SessionsController
  skip_before_filter :check_candidate, only: [:destroy]
end