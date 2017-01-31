class Answer < ActiveRecord::Base
  has_many :candidate_question_answers
  has_many :questions, through: :candidate_question_answers
end
