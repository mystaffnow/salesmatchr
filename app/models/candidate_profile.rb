# == Schema Information
#
# Table name: candidate_profiles
#
#  id                           :integer          not null, primary key
#  candidate_id                 :integer
#  city                         :string
#  state_id                     :integer
#  zip                          :string
#  education_level_id           :integer
#  ziggeo_token                 :string
#  is_incognito                 :boolean          default(TRUE)
#  linkedin_picture_url         :string
#  avatar_file_name             :string
#  avatar_content_type          :string
#  avatar_file_size             :integer
#  avatar_updated_at            :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  is_active_match_subscription :boolean          default(TRUE)
#

class CandidateProfile < ActiveRecord::Base
	belongs_to :candidate
	belongs_to :state
	belongs_to :education_level
	
  has_attached_file :avatar,  :default_url => "/img/missing.png", :styles => { :medium => "200x200#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_attached_file :resume, styles: {thumbnail: "60x60#"}
  validates_attachment :resume, content_type: { content_type: "application/pdf" }

  validates :candidate_id, uniqueness: true

  def avatar_url
    if is_incognito
      '/img/incognito.png'
    else
      if self.avatar.to_s == '/img/missing.png' && self.linkedin_picture_url
        self.linkedin_picture_url
      else
        self.avatar.url(:medium)
      end
    end
  end
end
