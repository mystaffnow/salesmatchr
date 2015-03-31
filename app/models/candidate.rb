class Candidate < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauth_providers => [:linkedin]
  has_many :experiences
  has_many :educations
  belongs_to :state
  belongs_to :education_level
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true

  def can_proceed
    self.archetype_score
  end
end
