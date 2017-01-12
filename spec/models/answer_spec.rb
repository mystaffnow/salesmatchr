require 'rails_helper'

RSpec.describe Answer do
	describe "Association" do
	  it {should have_many :questions}
    it {should have_many :candidate_question_answers}
	end
end