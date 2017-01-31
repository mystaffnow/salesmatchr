# == Schema Information
#
# Table name: employers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  company                :string
#  state_id               :integer
#  city                   :string
#  zip                    :string
#  description            :string
#  website                :string
#  ziggeo_token           :string
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
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class Employer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :state
  has_many :jobs

  has_attached_file :avatar,  :default_url => "/img/missing.png", :styles => { :medium => "200x200#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def is_owner_of?(obj)
    self.id == obj.try(:employer_id)
  end

  def can_proceed
    self.state.present? && self.city.present? && self.zip.present? && self.website.present? && self.name.present? && self.email.present?
  end
end
