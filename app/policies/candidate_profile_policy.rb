class CandidateProfilePolicy < ApplicationPolicy
	attr_reader :user, :profile

	def initialize(user, profile)
		@user = user
		@profile = profile
	end

	# if incognito ON, profile is visible to profile-owner and employers whose jobs profile-owner has applied
	# if incognito OFF, anyone can see the profile
	# ToDo: Testcase is remaining to modify
	def profile? 
		case user.class.name.to_s
			when "Candidate"
				user.is_owner_of?(profile) || (profile.is_incognito == false) 
			when "Employer"
				candidate_has_applied_employers_job?(profile, user) ||
				(profile.is_incognito == false)
			else
				profile.is_incognito == false
		end
	end

	private

	# checks if profile-owner has applied any of employer's job
	def candidate_has_applied_employers_job?(profile, user)
		candidate = profile.candidate
		employer = user
		employer_jobs_ids = employer.jobs.pluck(:id)
		job_candidates_ids = candidate.job_candidates.pluck(:job_id)
		(employer_jobs_ids & job_candidates_ids).present?
	end
end