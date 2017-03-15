require 'rails_helper'

RSpec.describe CandidateProfilePolicy do
	subject { described_class }

	let(:candidate) {create(:candidate)}
	let(:candidate1) {create(:candidate)}

	permissions :profile? do
		it 'denies access when profile setting is invisible' do
			candidate
			candidate1

			expect(CandidateProfile.last.is_incognito).to be_truthy
			expect(candidate.id).not_to eq(CandidateProfile.last.candidate_id)
			expect(subject).not_to permit(candidate, CandidateProfile.last)
		end

		it 'grant access when profile setting is visible' do
			candidate
			candidate1
			CandidateProfile.last.update(is_incognito: false)
			expect(CandidateProfile.last.is_incognito).to be_falsy
			expect(candidate.id).not_to eq(CandidateProfile.last.candidate_id)
			expect(subject).to permit(candidate, CandidateProfile.last)
		end

		it 'grant access for profile owner' do
			candidate
			candidate1
			expect(CandidateProfile.first.is_incognito).to be_truthy
			expect(subject).to permit(candidate, CandidateProfile.first)
			CandidateProfile.last.update(is_incognito: false)
			expect(CandidateProfile.last.is_incognito).to be_falsy
			expect(subject).to permit(candidate, CandidateProfile.last)
		end
	end
end