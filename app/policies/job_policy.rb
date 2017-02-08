class JobPolicy < ApplicationPolicy
	attr_reader :user, :job

	def initialize(user, job)
		@user = user
		@job = job
	end

	def index?
		true
	end

	def edit?
		user.is_owner_of?(job)
	end

	def update?
		user.is_owner_of?(job)
	end

	def new?
		user.is_a?(Employer)
	end

	def create?
		user.is_a?(Employer)
	end

	def destroy?
		user.is_owner_of?(job)
	end

	def employer_show?
		user.is_owner_of?(job)
	end

	def employer_show_actions?
		user.is_owner_of?(job)
	end

	def employer_show_shortlists?
		user.is_owner_of?(job)
	end

	def employer_show_matches?
		user.is_owner_of?(job)
	end

	def inactivate_job?
		user.is_owner_of?(job)
	end
end