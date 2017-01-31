# == Schema Information
#
# Table name: candidate_job_actions
#
#  id           :integer          not null, primary key
#  candidate_id :integer
#  job_id       :integer
#  is_saved     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CandidateJobActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
