require 'rails_helper'

RSpec.describe CandidateQuestionAnswer do
  describe "Association" do
    it {should belong_to :candidate}
    it {should belong_to :question}
    it {should belong_to :answer}
  end
end