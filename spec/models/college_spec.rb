# == Schema Information
#
# Table name: colleges
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe College do
	describe '.validation' do
		it {should validate_presence_of :name}
		it {should validate_uniqueness_of :name}
	end
end
