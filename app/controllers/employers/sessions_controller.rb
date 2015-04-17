class Employers::SessionsController < Devise::SessionsController
  skip_before_filter :check_employer, only: [:destroy]
end