# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  name       :string
#  answer_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Question do
  describe "Association" do
    it {should have_many :candidate_question_answers}
    it {should have_many(:answers).through(:candidate_question_answers)}
  end

  context 'nested attributes' do
    it { should accept_nested_attributes_for(:answers).allow_destroy(true) }
  end

  context 'validation' do
  	it {should validate_presence_of :name}
  	it {should validate_uniqueness_of :name}
  end
end
