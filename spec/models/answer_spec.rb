# == Schema Information
#
# Table name: answers
#
#  id         :integer          not null, primary key
#  name       :string
#  score      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Answer do
	describe "Association" do
    it {should have_many :candidate_question_answers}
    it {should have_many(:questions).through(:candidate_question_answers) }
	end
end
