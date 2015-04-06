class Job < ActiveRecord::Base
  belongs_to :state
  belongs_to :employer
  has_many :job_candidates
  has_many :candidate_job_actions
  attr_accessor :job_function_id

  def matches
    Candidate.where("archetype_score >= ? and archetype_score <= ?", self.archetype_low, self.archetype_high)
  end
end
