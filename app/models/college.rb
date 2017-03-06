# == Schema Information
#
# Table name: colleges
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class College < ActiveRecord::Base
	# validation
	validates_presence_of :name
	validates_uniqueness_of :name
	# validation
end
