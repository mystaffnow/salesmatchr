# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class State < ActiveRecord::Base
  # association
  has_many :candidate_profile
  has_many :employer_profile
  # association

  # validation
  validates_presence_of :name
  validates_uniqueness_of :name
  # validation
end
