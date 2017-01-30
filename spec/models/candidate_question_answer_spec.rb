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

require 'rails_helper'

RSpec.describe CandidateQuestionAnswer do
  describe "Association" do
    it {should belong_to :candidate}
    it {should belong_to :question}
    it {should belong_to :answer}
  end
end
