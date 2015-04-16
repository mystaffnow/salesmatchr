class CandidateQuestionAnswer < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :question
  belongs_to :answer

end
