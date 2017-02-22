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
	describe 'validation' do
		it {should have_many :candidate_profiles}
	end
end
