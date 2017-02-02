# == Schema Information
#
# Table name: candidate_question_answers
#
#  id           :integer          not null, primary key
#  candidate_id :integer
#  question_id  :integer
#  answer_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CandidateQuestionAnswer < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :question
  belongs_to :answer
end
