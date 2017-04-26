# == Schema Information
#
# Table name: employer_profiles
#
#  id                  :integer          not null, primary key
#  employer_id         :integer
#  website             :string
#  ziggeo_token        :string
#  zip                 :string
#  city                :string
#  state_id            :integer
#  description         :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class EmployerProfile < ActiveRecord::Base
	belongs_to :employer
	belongs_to :state

	validates :employer_id, uniqueness: true

	has_attached_file :avatar,  :default_url => '/img/missing.png', :styles => { :medium => "200x200#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
