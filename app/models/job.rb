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
  has_many :job_candidates, dependent: :destroy
  has_many :candidate_job_actions, dependent: :destroy
  # attr_accessor :job_function_id
  belongs_to :job_function
  has_one :payment, dependent: :destroy

  # validation
  validates :employer_id, :title, :description, :city, :zip, presence: true
  # validation

  # assign archetype scores values from job function before rec save
  before_save :add_archetype_score

  # this method returns all the candidates who matches the job and having their profile visible
  def matches
    # Candidate.where("candidates.archetype_score >= ? and candidates.archetype_score <= ? ", self.archetype_low, self.archetype_high).to_a
    Candidate.where("candidates.archetype_score >= ? and candidates.archetype_score <= ?", self.archetype_low, self.archetype_high).joins(:candidate_profile).where("candidate_profiles.is_incognito=false")
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

  # send email to job matched candidates
  def send_email
    candidates = Candidate.where("candidates.archetype_score >= ? and
                                  candidates.archetype_score <= ?", self.archetype_low,
                                                                    self.archetype_high)
                              .joins(:candidate_profile)
                              .where("candidate_profiles.is_active_match_subscription=true")
    if candidates.present?
      candidates.map {|candidate| CandidateMailer.send_job_match(candidate, self).deliver_later}
    end
    rescue => e
      self.destroy
      return nil
  end

  private

  # as job_function is required to post job so, assign archetype_low and high value from job_function do not accept from parameters
  def add_archetype_score
    self.archetype_low = job_function.low
    self.archetype_high = job_function.high
  end
end
