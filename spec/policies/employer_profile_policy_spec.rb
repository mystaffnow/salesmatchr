require 'rails_helper'

RSpec.describe EmployerProfilePolicy do
	subject { described_class }

	let(:state) {create(:state)}
	let(:employer) {create(:employer)}
	let(:employer1) {create(:employer)}
	let(:candidate) {create(:candidate)}

	permissions :profile? do
		it 'denies access when resource owner not found' do
			profile = employer_profile(employer)
			expect(subject).not_to permit(candidate, profile)
			expect(subject).not_to permit(employer1, profile)
		end

		it 'grant access when resource owner found' do
			profile = employer_profile(employer)
			expect(subject).to permit(employer, profile)
		end

		it 'denies access when resource owner is archived' do
			profile = employer_profile(employer)
			employer.update(deleted_at: Time.now)
			expect(Employer.first.deleted_at).not_to be_nil
			expect(subject).not_to permit(employer, profile)
		end

		it 'grant access when resource owner is is not archived' do
			profile = employer_profile(employer)
			expect(Employer.first.deleted_at).to be_nil
			expect(subject).to permit(employer, profile)
		end
	end
end