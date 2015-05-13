class Candidates::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  def edit
    super
  end
  def create
    super
    Question.all.each do |question|
      current_candidate.candidate_question_answers.build question_id: question.id
    end
    current_candidate.save
  end
  def update
    super
  end
  def new
    super
  end

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name,
               :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name,
               :email, :password, :password_confirmation, :current_password)
    end
  end
end