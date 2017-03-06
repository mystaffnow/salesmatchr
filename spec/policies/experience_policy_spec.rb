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
	end
end