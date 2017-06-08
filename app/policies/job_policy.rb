class JobPolicy < ApplicationPolicy
	attr_reader :user, :job

	def initialize(user, job)
		@user = user
		@job = job
	end

	def index?
		true
	end

	# when resource owner is archived it should not access by anyone
	# when resource owner is not archived visitors, users, can access when it is enable and active
	def show?
		!job.employer.archived? && ((job.enable? && job.is_active) || (
			user.present? && user.is_owner_of?(job))) 
	end

	def edit?
		user.is_owner_of?(job) && !user.archived?
	end

	def update?
		user.is_owner_of?(job) && !user.archived?
	end

	def new?
		user.is_a?(Employer) && !user.archived?
	end

	def create?
		user.is_a?(Employer) && !user.archived?
	end

	def destroy?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_show?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_show_actions?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_show_shortlists?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_show_remove?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_show_matches?
		user.is_owner_of?(job) && !user.archived?
	end

	def employer_archive?
		!user.archived?
	end

	def list_expired_jobs?
		!user.archived?
	end

	def inactivate_job?
		user.is_owner_of?(job) && !user.archived?
	end

	def email_match_candidates?
		user.is_owner_of?(job) && !user.archived?
	end

	def pay_to_enable_expired_job?
		user.is_owner_of?(job) && !user.archived?
	end

	def apply?
		!user.archived? && !job.employer.archived?
	end
end