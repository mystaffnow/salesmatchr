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

require 'test_helper'

class CandidateQuestionAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
