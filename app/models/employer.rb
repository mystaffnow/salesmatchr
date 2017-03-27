# == Schema Information
#
# Table name: employers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  company                :string
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
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

class Employer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :employer_profile, dependent: :destroy
  has_many :jobs, dependent: :destroy

  accepts_nested_attributes_for :employer_profile

  # validation
  validates_presence_of :first_name, :last_name, :company

  after_save :add_employer_profile

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def is_owner_of?(obj)
    self.id == obj.try(:employer_id)
  end

  def can_proceed
    return false if self.employer_profile.nil?
    self.employer_profile.state.present? && self.employer_profile.city.present? && self.employer_profile.zip.present? && self.employer_profile.website.present? && self.name.present? && self.email.present?
  end

  private

  def add_employer_profile
    if self.employer_profile.blank?
      profile = EmployerProfile.new(employer_id: self.id)
      profile.save
    end
  end
end
