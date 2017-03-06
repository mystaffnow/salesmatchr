# == Schema Information
#
# Table name: education_levels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EducationLevel < ActiveRecord::Base
	has_many :candidate_profiles

	# validation
	validates_presence_of :name
	validates_uniqueness_of :name
	# validation
end
