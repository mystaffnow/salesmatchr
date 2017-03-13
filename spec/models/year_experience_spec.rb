# == Schema Information
#
# Table name: year_experiences
#
#  id         :integer          not null, primary key
#  name       :string
#  low        :integer
#  high       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe YearExperience do
	context 'validation' do
  	it {should validate_presence_of :name}
  	it {should validate_presence_of :low}
  	it {should validate_presence_of :high}
  	it {should validate_uniqueness_of :name}
  end
end
