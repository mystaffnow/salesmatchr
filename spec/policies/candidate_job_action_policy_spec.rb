require 'rails_helper'

RSpec.describe CandidateJobActionPolicy do
	subject { described_class }

	let(:candidate) {create(:candidate)}
	let(:candidate1) {create(:candidate)}
	let(:employer) {create(:employer)}
	let(:state) {create(:state)}
	let(:job_function) {create(:job_function)}
	let(:job) {create(:job,
										 employer_id: employer.id, job_function_id: job_function.id,
										 state_id: state.id, city: 'test city', zip: 6050)}
	let(:candidate_job_action) {create(:candidate_job_action,
																				candidate_id: candidate.id,
																				job_id: job.id,
																				is_saved: false)}

	permissions :candidate_save_job? do																									
		it 'denies access when resource owner not found' do
			expect(subject).not_to permit(candidate1, candidate_job_action)
			expect(subject).not_to permit(employer, candidate_job_action)
		end
		
		it 'grant access when resource owner found' do
			expect(subject).to permit(candidate, candidate_job_action)
		end

		it 'denies access to profile owner if owner is archived' do
			candidate
			candidate.update deleted_at: Time.now
			expect(Candidate.first.deleted_at).not_to be_nil
			expect(subject).not_to permit(candidate, candidate_job_action)
		end

		it 'grant access to profile owner if owner is not archived' do
			candidate
			expect(Candidate.first.deleted_at).to be_nil
			expect(subject).to permit(candidate, candidate_job_action)
		end
	end

	permissions :candidate_job_saved?, :candidate_job_viewed?, :candidate_matches? do
		it 'denies access when resource owner is archived' do
			candidate
			candidate.update(deleted_at: Time.now)
			expect(Candidate.first.deleted_at).not_to be_nil
			expect(subject).not_to permit(candidate)
		end

		it 'grant access when resource owner is not archived' do
			candidate
			expect(Candidate.first.deleted_at).to be_nil
			expect(subject).to permit(candidate)
		end
	end
end