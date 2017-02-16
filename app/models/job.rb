# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  employer_id      :integer
#  salary_low       :integer
#  salary_high      :integer
#  zip              :string
#  is_remote        :boolean
#  title            :string
#  description      :text
#  is_active        :boolean          default(FALSE)
#  view_count       :integer
#  state_id         :integer
#  city             :string
#  archetype_low    :integer
#  archetype_high   :integer
#  job_function_id  :integer
#  latitude         :float
#  longitude        :float
#  stripe_token     :string
#  experience_years :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Job < ActiveRecord::Base
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  belongs_to :state
  belongs_to :employer
  has_many :job_candidates
  has_many :candidate_job_actions
  attr_accessor :job_function_id
  has_one :payment, dependent: :destroy

  # validation
  validates :employer_id, :title, :description, :city, :zip, presence: true
  # validation

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
  def deleted
    Candidate.joins(:job_candidates).where("job_candidates.job_id = ? and job_candidates.status = ?", self.id, JobCandidate.statuses[:deleted])
  end
  def full_street_address
    self.city + " " + self.state.name + " " + self.zip
  end
end
