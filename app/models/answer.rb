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

class Answer < ActiveRecord::Base
  has_many :candidate_question_answers
  has_many :questions, through: :candidate_question_answers

  # validation
  validates_presence_of :name, :score
	validates_uniqueness_of :name
end
