class CandidateJobActionPolicy < ApplicationPolicy
	attr_reader :user, :candidate_job_action

	def initialize(user, candidate_job_action)
		@user = user
		@candidate_job_action = candidate_job_action
	end

	def candidate_save_job?
    user.is_owner_of?(candidate_job_action) && !user.archived?
	end
end