# == Schema Information
#
# Table name: sales_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SalesType do
	context 'validation' do
  	it {should validate_presence_of :name}
  	it {should validate_uniqueness_of :name}
  end
end
