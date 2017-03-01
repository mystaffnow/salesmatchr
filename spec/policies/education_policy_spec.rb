require 'rails_helper'

RSpec.describe EducationPolicy do
	subject { described_class }

	permissions :destroy? do
		let(:candidate1) {create(:candidate)}
		let(:candidate2) {create(:candidate)}
		let(:education) {create(:education, candidate_id: candidate1.id)}
		let(:employer) {create(:employer)}

		it 'denies access when resource owner not found' do
			expect(subject).not_to permit(candidate2, education)
			expect(subject).not_to permit(employer, education)
		end

		it 'grant access when resource owner found' do
			expect(subject).to permit(candidate1, education)
		end
	end
end