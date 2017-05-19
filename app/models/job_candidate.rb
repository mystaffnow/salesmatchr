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
  # association
  belongs_to :job
  belongs_to :candidate

  # validation
  validates_presence_of :candidate_id, :job_id, :status
  validates_uniqueness_of :candidate_id, scope: :job_id

  enum status: [:submitted, :viewed, :accepted, :withdrawn,
                :shortlist, :deleted, :purposed]

  # method returns job_candidates record for active and enable job
  scope :active_job_candidate_list, ->(current_candidate) {
  																		where(:candidate_id => current_candidate.id)
                											.joins(:job)
                											.where('jobs.status=0 and jobs.is_active=true')}

  # method return statuses values on array             											
  def self.statuses_opened
  	arr = Array.new
  	arr << JobCandidate.statuses['submitted']
  	arr << JobCandidate.statuses['viewed']
  	arr << JobCandidate.statuses['shortlist']
  	arr << JobCandidate.statuses['accepted']
  	arr << JobCandidate.statuses['deleted']
  	arr << JobCandidate.statuses['purposed']
  	return arr
  end

  # used by views
  def is_applicants?
    (self.submitted? || self.viewed? || self.purposed?)
  end
end
