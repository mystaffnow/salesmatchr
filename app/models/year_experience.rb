# == Schema Information
#
# Table name: year_experiences
#
#  id         :integer          not null, primary key
#  name       :string
#  low        :integer
#  high       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class YearExperience < ActiveRecord::Base
end
