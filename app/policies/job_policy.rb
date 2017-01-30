class JobPolicy < ApplicationPolicy
	attr_reader :user, :job

	def initialize(user, job)
		@user = user
		@job = job
	end

	def edit?
		user.is_owner_of?(job)
	end

	def update?
		user.is_owner_of(job)
	end

	def new?
		user.is_a?(Employer)
	end

	def create?
		user.is_a?(Employer)
	end
end