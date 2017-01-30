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

require 'test_helper'

class EducationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
