class EmployerProfilePolicy < ApplicationPolicy
	attr_reader :user, :profile

	def initialize(user, profile)
		@user = user
		@profile = profile
	end

	def profile?
		user.is_owner_of?(profile)
	end

	def account?
		user.is_owner_of?(profile)
	end

	def update?
		user.is_owner_of?(profile)
	end
end