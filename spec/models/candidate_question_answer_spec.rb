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

  it '#calculate_archetype_score' do
    candidate = create(:candidate)
    
    question = create(:question)
    question2 = create(:question_second)
    question3 = create(:question_third)
    question4 = create(:question_fourth)
    question5 = create(:question_fifth)
    question6 = create(:question_sixth)
    question7 = create(:question_seventh)
    question8 = create(:question_eighth)
    question9 = create(:question_ninth)
    question10 = create(:question_tenth)
    question11 = create(:question_eleventh)
    question12 = create(:question_twelveth)
    question13 = create(:question_thirteenth)
    question14 = create(:question_fourteenth)
    question15 = create(:question_fifteenth)
    question16 = create(:question_sixteenth)
    question17 = create(:question_seventeenth)
    question18 = create(:question_eighteenth)
    question19 = create(:question_nineteenth)
    question20 = create(:question_twentieth)
    
    strongly_agree = create(:answer)
    agree = create(:agree)
    strongly_disagree = create(:strongly_disagree)
    neutral = create(:neutral)
    disagree = create(:disagree)
    
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question.id, answer_id: strongly_agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question2.id, answer_id: agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question3.id, answer_id: strongly_disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question4.id, answer_id: neutral.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question5.id, answer_id: disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question6.id, answer_id: strongly_agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question7.id, answer_id: agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question8.id, answer_id: strongly_disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question9.id, answer_id: neutral.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question10.id, answer_id: disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question11.id, answer_id: strongly_agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question12.id, answer_id: agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question13.id, answer_id: strongly_disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question14.id, answer_id: neutral.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question15.id, answer_id: disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question16.id, answer_id: strongly_agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question17.id, answer_id: agree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question18.id, answer_id: strongly_disagree.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question19.id, answer_id: neutral.id)
    create(:candidate_question_answer, candidate_id: candidate.id, question_id: question20.id, answer_id: disagree.id)
  
    expect(CandidateQuestionAnswer.calculate_archetype_score(candidate)).not_to be_nil
    expect(CandidateQuestionAnswer.calculate_archetype_score(candidate)).to eq(100)
  end
end
