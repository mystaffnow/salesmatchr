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

class CandidateJobAction < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :job
end
