# == Schema Information
#
# Table name: education_levels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe EducationLevel do
	describe 'association' do
		it {should have_many :candidate_profiles}
	end

	describe 'validation' do
		it {should validate_presence_of :name}
		it {should validate_uniqueness_of :name}
	end
end
