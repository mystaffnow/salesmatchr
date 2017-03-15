class CandidateProfilePolicy < ApplicationPolicy
	attr_reader :user, :profile

	def initialize(user, profile)
		@user = user
		@profile = profile
	end

	# unauthorize if profile setting is invisible
	def profile?
		res = user.is_owner_of?(profile)
		if res
			true
		else
			profile.is_incognito == false
		end
	end
end