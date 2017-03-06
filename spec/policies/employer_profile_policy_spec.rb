require 'rails_helper'

RSpec.describe EmployerProfilePolicy do
	subject { described_class }

	let(:state) {create(:state)}
	let(:employer) {create(:employer)}
	let(:employer1) {create(:employer)}
	let(:candidate) {create(:candidate)}

	permissions :profile?, :account?, :update? do
		it 'denies access when resource owner not found' do
			profile = employer_profile(employer)
			expect(subject).not_to permit(candidate, profile)
			expect(subject).not_to permit(employer1, profile)
		end

		it 'grant access when resource owner found' do
			profile = employer_profile(employer)
			expect(subject).to permit(employer, profile)
		end
	end
end