class Answer < ActiveRecord::Base
  has_many :questions
  has_many :candidate_quesiton_answers
end
