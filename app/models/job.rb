class Job < ActiveRecord::Base
  belongs_to :state
  belongs_to :employer
  has_many :job_candidates

end
