class Question < ActiveRecord::Base
  has_many :candidate_question_answers
  has_many :answers, through: :candidate_question_answers
  accepts_nested_attributes_for :answers, allow_destroy: true
end
