require 'rails_helper'

RSpec.describe ExperiencePolicy do
	subject { described_class }

	permissions :destroy? do
		let(:candidate1) {create(:candidate)}
		let(:candidate2) {create(:candidate)}
		let(:experience) {create(:experience, candidate_id: candidate1.id)}
		let(:employer) {create(:employer)}

		it 'denies access when resource owner not found' do
			expect(subject).not_to permit(candidate2, experience)
			expect(subject).not_to permit(employer, experience)
		end

		it 'grant access when resource owner found' do
			expect(subject).to permit(candidate1, experience)
		end

		it 'denies access to profile owner if owner is archived' do
			candidate1
			candidate1.update deleted_at: Time.now
			expect(Candidate.first.deleted_at).not_to be_nil
			expect(subject).not_to permit(candidate1, experience)
		end

		it 'grant access to profile owner if owner is not archived' do
			candidate1
			expect(Candidate.first.deleted_at).to be_nil
			expect(subject).to permit(candidate1, experience)
		end
	end
end