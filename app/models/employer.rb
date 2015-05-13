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
    self.first_name + " " + self.last_name
  end
  def can_proceed
    self.state && self.city && self.zip && self.website && self.name && self.email
  end
end
