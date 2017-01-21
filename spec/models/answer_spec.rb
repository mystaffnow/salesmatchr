require 'rails_helper'

RSpec.describe Answer do
	describe "Association" do
    it {should have_many :candidate_question_answers}
    it {should have_many(:questions).through(:candidate_question_answers) }
	end
end