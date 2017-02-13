# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe State do
  describe 'association' do
    it {should have_many :candidate_profile}
    it {should have_many :employer_profile}
  end
end
