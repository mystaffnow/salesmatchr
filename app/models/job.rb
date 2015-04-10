class Job < ActiveRecord::Base
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  belongs_to :state
  belongs_to :employer
  has_many :job_candidates
  has_many :candidate_job_actions
  attr_accessor :job_function_id

  def matches
    Candidate.where("archetype_score >= ? and archetype_score <= ?", self.archetype_low, self.archetype_high)
  end
  def full_street_address
    self.city + " " + self.state.name + " " + self.zip
  end
end
