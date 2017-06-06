class ExperiencePolicy < ApplicationPolicy
	attr_reader :user, :experience

	def initialize(user, experience)
		@user = user
		@experience = experience
	end

	def destroy?
		user.is_owner_of?(experience) && !user.archived?
	end
end