class JobCandidatePolicy < ApplicationPolicy
	attr_reader :user, :job_candidate

	def initialize(user, job_candidate)
		@user = user
		@job_candidate = job_candidate
	end

	def remove_candidate?
		user.is_owner_of?(job_candidate.job)
	end

	def shortlist_candidate?
		user.is_owner_of?(job_candidate.job)
	end

	def withdraw?
		user.is_owner_of?(job_candidate)
	end

	def accept_candidate?
		user.is_owner_of?(job_candidate.job)
	end

	def receipt?
		user.is_owner_of?(job_candidate)
	end
end