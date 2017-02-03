class EmployerProfile < ActiveRecord::Base
	belongs_to :employer
	belongs_to :state

	validates :employer_id, uniqueness: true

	has_attached_file :avatar,  :default_url => "/img/missing.png", :styles => { :medium => "200x200#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
