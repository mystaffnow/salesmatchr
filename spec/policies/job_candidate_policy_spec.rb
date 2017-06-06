require 'rails_helper'

RSpec.describe JobCandidatePolicy do
	subject { described_class }

	let(:state) {create(:state)}
	let(:job_function) {create(:job_function)}
	let(:employer) {create(:employer)}
	let(:job) {create(:job, employer_id: employer.id,
												  state_id: state.id,
													job_function_id: job_function.id,
													city: 'test city', zip: 5020)}
	let(:candidate) {create(:candidate)}
	let(:job_candidate) {create(:job_candidate, candidate_id: candidate.id,
																							job_id: job.id,
																							status: 'submitted')}
	let(:candidate1) {create(:candidate)}
	let(:employer1) {create(:employer)}

	permissions :remove_candidate?, :shortlist_candidate?, :accept_candidate? do
		it 'denies access to candidate and non-resource-owner' do
			expect(subject).not_to permit(employer1, job_candidate)
			expect(subject).not_to permit(candidate, job_candidate)
			expect(subject).not_to permit(candidate1, job_candidate)
		end

		it 'grant access to resource-owner' do
			expect(subject).to permit(employer, job_candidate)
		end
	end

	permissions :withdraw?, :receipt? do
		it 'denies access to employer and non-resource-owner' do
			expect(subject).not_to permit(employer, job_candidate)
			expect(subject).not_to permit(employer1, job_candidate)
			expect(subject).not_to permit(candidate1, job_candidate)
		end

		it 'grant access to resource-owner' do
			expect(subject).to permit(candidate, job_candidate)
		end

		it 'denies access to profile owner if owner is archived' do
			candidate
			candidate.update deleted_at: Time.now
			expect(Candidate.first.deleted_at).not_to be_nil
			expect(subject).not_to permit(candidate, job_candidate)
		end

		it 'grant access to profile owner if owner is not archived' do
			candidate
			expect(Candidate.first.deleted_at).to be_nil
			expect(subject).to permit(candidate, job_candidate)
		end
	end
end