require 'rails_helper'

RSpec.describe CandidateProfilePolicy do
	subject { described_class }

	let(:candidate) {create(:candidate)}
	let(:candidate1) {create(:candidate)}
	let(:employer) {create(:employer)}

	permissions :profile? do
		it 'grant access to profile owner when incognito ON' do
			candidate
			expect(CandidateProfile.first.is_incognito).to be_truthy
			expect(subject).to permit(candidate, CandidateProfile.first)
		end

		it 'grant access to employer when candidate is applicant on his job and when profile incognito ON' do
			candidate
			candidate1
			employer
			@job = create(:job, employer_id: employer.id)
			JobCandidate.create(job_id: @job.id, candidate_id: candidate.id, status: JobCandidate.statuses["submitted"])
			expect(CandidateProfile.first.is_incognito).to be_truthy
			expect(CandidateProfile.last.is_incognito).to be_truthy
			expect(subject).to permit(employer, CandidateProfile.first)
			expect(subject).not_to permit(employer, CandidateProfile.last)
		end

		it 'denies access to other candidates, employers, end-users, when incognito ON' do
			candidate
			candidate1
			employer
			expect(CandidateProfile.first.is_incognito).to be_truthy
			expect(subject).not_to permit(candidate1, CandidateProfile.first)
			expect(subject).not_to permit(employer, CandidateProfile.last)
			expect(subject).not_to permit(nil, CandidateProfile.last)
		end

		it 'grant access to profile owner, employer, other candidates and end-users, when profile incognito OFF' do
			candidate
			candidate1
			employer
			CandidateProfile.first.update(is_incognito: false)
			expect(CandidateProfile.first.is_incognito).to be_falsy
			expect(subject).to permit(candidate, CandidateProfile.first)
			expect(subject).to permit(candidate1, CandidateProfile.first)
			expect(subject).to permit(employer, CandidateProfile.first)
			expect(subject).to permit(nil, CandidateProfile.first)
		end
	end
end
