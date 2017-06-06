class EducationPolicy < ApplicationPolicy
	attr_reader :user, :education

	def initialize(user, education)
		@user = user
		@education = education
	end

	def destroy?
		user.is_owner_of?(education) && !user.archived?
	end
end