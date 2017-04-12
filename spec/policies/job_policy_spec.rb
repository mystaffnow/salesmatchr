require 'rails_helper'

RSpec.describe JobPolicy do
	subject { described_class }

	let(:candidate) {create(:candidate)}
	let(:employer) {create(:employer)}
	let(:job_function) {create(:job_function)}
	let(:state) {create(:state)}
	let(:job) {create(:job, employer_id: employer.id,
													job_function_id: job_function.id,
													state_id: state.id,
													city: 'test city',
													zip: 5020, is_active: true)}
	let(:employer1) {create(:employer)}
	
	permissions :edit?, :update?, :destroy?, :employer_show?, :employer_show_actions?,
							:employer_show_shortlists?, :employer_show_remove?, :employer_show_matches?,
							:inactivate_job?, :email_match_candidates?, :pay_to_enable_expired_job? do

		it 'denies access when resource owner not found' do
			expect(subject).not_to permit(candidate, job)
			expect(subject).not_to permit(employer1, job)
		end

		it 'grant acess when resource owner found' do
			expect(subject).to permit(employer, job)
		end
	end

	permissions :new?, :create? do
		it 'denies when employer is not signed in' do
			expect(subject).not_to permit(candidate)
		end

		it 'grant access when employer is signed in' do
			expect(subject).to permit(employer)
		end
	end

	permissions :index? do
		it 'can access by anyone' do
			expect(subject).to permit(employer)
			expect(subject).to permit(candidate)
		end
	end

	permissions :show? do
		it 'permit access by anyone when job is enabled and active' do
			expect(job.enable?).to be_truthy
			expect(job.is_active).to be_truthy
			expect(subject).to permit(candidate, job)
			expect(subject).to permit(employer, job)
			expect(subject).to permit(nil, job)
		end

		it 'denies access to candidate and visitors when job disable' do
			job.update(status: 1)
			expect(subject).not_to permit(candidate, job)
			expect(subject).not_to permit(nil, job)
		end

		it 'permit resource owner when job disable' do
			job.update(status: 1)
			expect(subject).to permit(employer, job)
		end

		it 'denies access to candidate and visitors when job inactive' do
			job.update(is_active: false)
			expect(subject).not_to permit(candidate, job)
			expect(subject).not_to permit(nil, job)
		end

		it 'permit resource owner when job inactive' do
			job.update(is_active: false)
			expect(subject).to permit(employer, job)
		end

		it 'denies access to candidate & visitors, when job inactive and disable' do
			job.update(is_active: false, status: 1)
			expect(subject).not_to permit(candidate, job)
			expect(subject).not_to permit(nil, job)
		end

		it 'permit resource owner when job inactive and disable' do
			job.update(is_active: false, status: 1)
			expect(subject).to permit(employer, job)
		end
	end
end