# == Schema Information
#
# Table name: job_functions
#
#  id         :integer          not null, primary key
#  name       :string
#  low        :integer
#  high       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobFunction < ActiveRecord::Base
end
