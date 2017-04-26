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
#  status           :integer          default(0)
#  is_active        :boolean          default(FALSE)
#  activated_at     :datetime
#

class Job < ActiveRecord::Base
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  belongs_to :state
  belongs_to :employer
  has_many :job_candidates, dependent: :destroy
  has_many :candidate_job_actions, dependent: :destroy
  belongs_to :job_function
  has_many :payments, dependent: :destroy

  # validation
  validates :employer_id, :title, :description, :city, :zip, presence: true
  # validation

  # define enum for job statuses
  enum status: [:enable, :expired]

  # assign archetype scores values from job function before rec save
  before_save :add_archetype_score

  scope :active, -> {where(is_active: true)}

  # List all jobs which are active and matched to the candidate
  # Candidate should not see inactive jobs in matched list, although they matched to it
  scope :job_matched_list, ->(current_candidate) {enable.where(':archetype_score >= archetype_low and
                                    :archetype_score <= archetype_high and
                                    jobs.is_active = true',
                                    archetype_score: current_candidate.archetype_score)}

  # List of the enable jobs which are viewed by candidate
  scope :job_viewed_list, ->(current_candidate) {
    enable.active.joins(:candidate_job_actions)
    .where('candidate_job_actions.candidate_id=?', current_candidate.id)
    .order('created_at DESC')
  }

  # list of enable jobs saved by candidate
  scope :job_saved_list, ->(current_candidate) {
    enable.active.joins(:candidate_job_actions)
    .where('candidate_job_actions.candidate_id=?
            and candidate_job_actions.is_saved=true', current_candidate.id)
  }

  # list of all visible candidates who have viewed particular job
  scope :visible_candidate_viewed_list, ->(job) {
    Candidate.joins(:candidate_job_actions)
    .joins(:candidate_profile)
    .where('job_id=? and candidate_profiles.is_incognito=false', job.id)
  }

  # this method returns all the candidates who matches the job and having their
  # profile visible
  def candidate_matches_list
    Candidate.where('candidates.archetype_score >= ?
                     and candidates.archetype_score <= ?',
                    self.archetype_low,
                    self.archetype_high)
              .joins(:candidate_profile)
              .where('candidate_profiles.is_incognito=false')
              .order(id: :asc)
  end

  # send email to job matched candidates who have subscribe to matched alert
  def send_email_to_matched_candidates
    error_code = 0

    # email alert should not work for expired job
    return error_code if self.expired?

    candidates = Candidate.where('candidates.archetype_score >= ? and
                                  candidates.archetype_score <= ?', self.archetype_low,
                                                                    self.archetype_high)
                              .joins(:candidate_profile)
                              .where('candidate_profiles.is_active_match_subscription=true')

    candidates.map {|candidate| CandidateMailer.send_job_match(candidate, self).deliver_later}
    return error_code

    rescue => e
      return error_code = 500
  end

  def applicants
    arr = Array.new
    arr << JobCandidate.statuses[:shortlist] << JobCandidate.statuses[:deleted]
    Candidate.joins(:job_candidates).where('job_candidates.job_id = ?
                                            and job_candidates.status not in (?)',
                                            self.id, arr)
  end

  def shortlist
    Candidate.joins(:job_candidates).where('job_candidates.job_id = ? and
                                            job_candidates.status = ?',
                                            self.id, JobCandidate.statuses[:shortlist])
  end

  def deleted
    Candidate.joins(:job_candidates).where('job_candidates.job_id = ? and
                                            job_candidates.status = ?',
                                            self.id, JobCandidate.statuses[:deleted])
  end

  def full_street_address
    self.city + ' ' + self.state.name + ' ' + self.zip
  end

  # Created to test expired jobs from TestCase
  # def self.expired_jobs
  #   where("? > activated_at", 30.days.ago)
  # end

  private

  # as job_function is required to post job so, assign archetype_low and high value
  # from job_function do not accept from parameters
  def add_archetype_score
    if job_function.present?
      self.archetype_low = job_function.low
      self.archetype_high = job_function.high
    end
  end
end
