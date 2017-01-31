# == Schema Information
#
# Table name: job_candidates
#
#  id           :integer          not null, primary key
#  candidate_id :integer
#  job_id       :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class JobCandidate < ActiveRecord::Base
  belongs_to :job
  belongs_to :candidate

  enum status: [ :submitted, :viewed, :accepted, :withdrawn, :shortlist, :deleted, :purposed]
end
