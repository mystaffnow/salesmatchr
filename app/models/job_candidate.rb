class JobCandidate < ActiveRecord::Base
  belongs_to :job
  belongs_to :candidate

  enum status: [ :submitted, :viewed, :accepted, :withdrawn]
end
