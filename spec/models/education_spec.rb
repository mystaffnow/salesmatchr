# == Schema Information
#
# Table name: educations
#
#  id                 :integer          not null, primary key
#  college_id         :integer
#  college_other      :string
#  education_level_id :integer
#  description        :string
#  start_date         :date
#  end_date           :date
#  candidate_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Education do
	it {should belong_to :education_level}
  it {should belong_to :college}
end
