class CandidateProfile < ActiveRecord::Base
	belongs_to :candidate
	belongs_to :state
	belongs_to :education_level
	
  attr_accessor :avatar
  has_attached_file :avatar,  :default_url => "/img/missing.png", :styles => { :medium => "200x200#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :candidate_id, uniqueness: true

  def avatar_url
    if is_incognito
      '/img/incognito.png'
    else
      if self.avatar.to_s == "/img/missing.png" && self.linkedin_picture_url
        self.linkedin_picture_url
      else
        self.avatar.url(:medium)
      end
    end

  end
end
