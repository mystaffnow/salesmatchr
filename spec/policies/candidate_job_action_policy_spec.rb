require 'rails_helper'

RSpec.describe CandidateJobActionPolicy do
	subject { described_class }

	permissions :candidate_save_job? do
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
																											
		it 'denies access when resource owner not found' do
			expect(subject).not_to permit(candidate1, candidate_job_action)
			expect(subject).not_to permit(employer, candidate_job_action)
		end
		
		it 'grant access when resource owner found' do
			expect(subject).to permit(candidate, candidate_job_action)
		end
	end
end