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

class Question < ActiveRecord::Base
  has_many :candidate_question_answers
  has_many :answers, through: :candidate_question_answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  # validation
	validates_presence_of :name
	validates_uniqueness_of :name
	# validation
end
