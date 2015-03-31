class JobCandidate < ActiveRecord::Base
  belongs_to :job
  belongs_to :candidate
end
