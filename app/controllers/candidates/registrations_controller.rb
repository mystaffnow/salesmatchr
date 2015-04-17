class Candidates::RegistrationsController < Devise::RegistrationsController
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
end