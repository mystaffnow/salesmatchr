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
  # association
  belongs_to :candidate
  belongs_to :job

  # validation
  validates_presence_of :candidate_id, :job_id
  # same mirror record should not be created again
  validates_uniqueness_of :candidate_id, scope: :job_id
end
