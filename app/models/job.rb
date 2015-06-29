class Job < ActiveRecord::Base
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  belongs_to :state
  belongs_to :employer
  has_many :job_candidates
  has_many :candidate_job_actions
  attr_accessor :job_function_id

  def matches
    matches = Candidate.where("candidates.archetype_score >= ? and candidates.archetype_score <= ? ", self.archetype_low, self.archetype_high).to_a
    matches
  end
  def applicants
    arr = Array.new
    arr << JobCandidate.statuses[:shortlist] << JobCandidate.statuses[:deleted]
    Candidate.joins(:job_candidates).where("job_candidates.job_id = ? and job_candidates.status not in (?)", self.id, arr)
  end
  def shortlist
    Candidate.joins(:job_candidates).where("job_candidates.job_id = ? and job_candidates.status = ?", self.id, JobCandidate.statuses[:shortlist])
  end
  def full_street_address
    self.city + " " + self.state.name + " " + self.zip
  end
end
