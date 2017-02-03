# == Schema Information
#
# Table name: candidates
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  city                   :string
#  state_id               :integer
#  zip                    :string
#  education_level_id     :integer
#  archetype_score        :integer
#  ziggeo_token           :string
#  uid                    :string
#  provider               :string
#  is_incognito           :boolean
#  year_experience_id     :integer
#  linkedin_picture_url   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class Candidate < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
  :recoverable, :rememberable, :trackable, :validatable,:omniauth_providers => [:linkedin]
  has_one :candidate_profile
  has_many :experiences
  has_many :educations
  has_many :candidate_question_answers
  has_many :job_candidates
  # belongs_to :state
  # belongs_to :education_level
  belongs_to :year_experience
  accepts_nested_attributes_for :candidate_profile
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :candidate_question_answers, allow_destroy: true
  attr_accessor :flash_notice
  attr_accessor :avatar
  # has_attached_file :avatar,  :default_url => "/img/missing.png", :styles => { :medium => "200x200#" }
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def name
    return self.first_name + " " + self.last_name
  end

  def is_owner_of?(obj)
    self.id == obj.try(:candidate_id)
  end

  # def self.from_omniauth(auth)
  #   candidate = Candidate.where(uid: auth.uid).first
  #   if !candidate
  #     logger.debug("create new candidate")
  #     logger.debug(auth[:extra][:raw_info]['pictureUrl'])
  #     candidate = Candidate.new
  #     candidate.first_name = auth.info.first_name
  #     candidate.last_name = auth.info.last_name
  #     candidate.provider = auth.provider
  #     candidate.uid = auth.uid
  #     candidate.email = auth.info.email
  #     if auth[:extra][:raw_info]['pictureUrl']
  #       candidate.linkedin_picture_url = auth[:extra][:raw_info]['pictureUrl']
  #     end

  #     Question.all.each do |question|
  #       candidate.candidate_question_answers.build question_id: question.id
  #     end

  #     auth[:extra][:raw_info][:positions][:values].each do |raw_experience|
  #       experience = candidate.experiences.build
  #       experience.is_current = raw_experience.isCurrent
  #       experience.company = raw_experience[:company].name
  #       experience.position = raw_experience.title
  #       logger.debug(raw_experience[:startDate].inspect)
  #       if raw_experience[:startDate]
  #         if raw_experience[:startDate].month
  #           experience.start_date =  Date.new(raw_experience[:startDate].year, raw_experience[:startDate].month)
  #         else
  #           experience.start_date =  Date.new(raw_experience[:startDate].year)
  #         end
  #       end
  #       if raw_experience[:endDate]
  #         experience.end_date =  Date.new(raw_experience[:endDate].year, raw_experience[:endDate].month)
  #       end
  #     end
  #     candidate.flash_notice = auth[:extra][:raw_info][:positions][:values].count.to_s + " job positions imported from linkedin"
  #   end
  #   candidate.save
  #   candidate
  # end
  def has_applied(job)
    JobCandidate.where(:job_id => job.id, :candidate_id => self.id).count > 0
  end
  def job_status(job)
    JobCandidate.where(:job_id => job.id, :candidate_id => self.id).first.status
  end
  def view_job(job)
    CandidateJobAction.create job_id: job.id, candidate_id: self.id, is_saved: false
  end
  def can_proceed
    self.archetype_score
  end
  def password_required?
    super #&& provider.blank?
  end
  def email_required?
    super #&& provider.blank?
  end
  # def avatar_url
  #   if is_incognito
  #     '/img/incognito.png'
  #   else
  #     if self.avatar.to_s == "/img/missing.png" && self.linkedin_picture_url
  #       self.linkedin_picture_url
  #     else
  #       self.avatar.url(:medium)
  #     end
  #   end

  # end
  def archetype_string
    if !self.archetype_score
      return 'n/a'
    end
    if self.archetype_score > 71
      return "Aggressive Hunter"
    elsif self.archetype_score > 31
      return "Relaxed Hunter"
    elsif self.archetype_score > 11
      return "Aggressive Fisherman"
    elsif self.archetype_score > -10
      return "Balanced Fisherman"
    elsif self.archetype_score > -30
      return "Relaxed Fisherman"
    elsif self.archetype_score > -70
      return "Aggressive Farmer"
    else
      return "Relaxed Farmer"
    end
  end

end
