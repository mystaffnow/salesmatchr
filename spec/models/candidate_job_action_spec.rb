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

require 'rails_helper'

RSpec.describe CandidateJobAction do
  describe "Association" do
    it {should belong_to :candidate}
    it {should belong_to :job}
  end
end
