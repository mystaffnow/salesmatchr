class CandidateJobAction < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :job
end
