class JobCandidatePolicy < ApplicationPolicy
	attr_reader :user, :job_candidate

	def initialize(user, job_candidate)
		@user = user
		@job_candidate = job_candidate
	end

	def remove_candidate?
		user.is_owner_of?(job_candidate.job) && !user.archived?
	end

	def shortlist_candidate?
		user.is_owner_of?(job_candidate.job) && !user.archived?
	end

	# candidate side
	def withdraw?
		user.is_owner_of?(job_candidate) && !user.archived?
	end

	def accept_candidate?
		user.is_owner_of?(job_candidate.job) && !user.archived?
	end

	# candidate side
	def receipt?
		user.is_owner_of?(job_candidate) && !user.archived?
	end
end