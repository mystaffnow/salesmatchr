# == Schema Information
#
# Table name: candidates
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  archetype_score        :integer
#  year_experience_id     :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#

require 'rails_helper'

RSpec.describe Candidate do
	let(:employer) {create(:employer, :first_name => "test", :last_name => "employer")}
	let(:state) {create(:state)}
	let(:job_function) {create(:job_function)}
	let(:job) {create(:job, employer_id: employer.id, state_id: state.id, city: 'New york', zip: 10900, job_function_id: job_function.id)}
	let(:candidate) {create(:candidate, :first_name => "test", :last_name => "candidate")}

	describe 'Validation' do
		it {should validate_presence_of(:first_name)}
		it {should validate_presence_of(:last_name)}
	end

	describe "Association" do
		it {should have_one(:candidate_profile).dependent(:destroy)}
		it {should have_many(:experiences).dependent(:destroy)}
		it {should have_many(:educations).dependent(:destroy)}
		it {should have_many(:candidate_question_answers).dependent(:destroy)}
		it {should have_many(:job_candidates).dependent(:destroy)}
		it {should have_many(:candidate_job_actions).dependent(:destroy)}
		it {should belong_to :year_experience}
	end

	context 'nested attributes' do
		it{ should accept_nested_attributes_for(:candidate_profile) }
		it{ should accept_nested_attributes_for(:experiences).allow_destroy(true) }
		it{ should accept_nested_attributes_for(:educations).allow_destroy(true) }
		it{ should accept_nested_attributes_for(:candidate_question_answers).allow_destroy(true) }
	end

	it 'should build candidate profile automatically' do
		@candidate = create(:candidate)
		@candidate.reload
		expect(@candidate.candidate_profile).to be_a(CandidateProfile)
		expect(@candidate.candidate_profile.candidate_id).to eq(@candidate.id)
		expect(@candidate.candidate_profile.city).to be_nil
	end

	it 'should not build candidate profile when already there' do
		@candidate = build(:candidate)
		@candidate.candidate_profile = build(:candidate_profile)
		@candidate.save
		expect(Candidate.count).to eq(1)
		expect(CandidateProfile.count).to eq(1)
		expect(CandidateProfile.first.candidate_id).to eq(@candidate.id)
		expect(CandidateProfile.first.city).to eq("test city")
	end
	
	context 'name' do
		it 'should return full_name of candidate' do
			expect(candidate.name).to eq('test candidate')
		end
	end

	it '#is_owner_of?' do
		@candidate = candidate
		CandidateProfile.first.update(candidate_id: @candidate.id)
		expect(@candidate.is_owner_of?(CandidateProfile.first)).to be_truthy
	end

	context 'has_applied-job' do
		it 'should return false if candidate has not applied a job' do
			expect(candidate.has_applied(job)).to eq(false)
		end

		it 'should return true if candidate has applied a job' do
			create(:job_candidate, job_id: job.id, candidate_id: candidate.id)
			expect(candidate.has_applied(job)).to eq(true)
		end
	end

	context 'job_status-job' do
		before(:each) do
			@job_candidate = create(:job_candidate, job_id: job.id, candidate_id: candidate.id)
		end

		it 'should equals submitted' do
			@job_candidate.status = 0
			expect(@job_candidate.status).to eq("submitted")
		end

		it 'should equals viewed' do
			@job_candidate.status = 1
			expect(@job_candidate.status).to eq("viewed")
		end

		it 'should equals accepted' do
			@job_candidate.status = 2
			expect(@job_candidate.status).to eq("accepted")
		end

		it 'should equals withdrawn' do
			@job_candidate.status = 3
			expect(@job_candidate.status).to eq("withdrawn")
		end

		it 'should equals shortlist' do
			@job_candidate.status = 4
			expect(@job_candidate.status).to eq("shortlist")
		end

		it 'should equals deleted' do
			@job_candidate.status = 5
			expect(@job_candidate.status).to eq("deleted")
		end
	end

	context 'view_job-job' do
		before(:each) do
			@candidate_job_action =	candidate.view_job(job)
		end

		it 'should create record of candidate_job_action' do
			expect(CandidateJobAction.count).to eq(1)
		end

		it 'should match candidate_id' do
			expect(@candidate_job_action.candidate_id).to eq(candidate.id)
		end

		it 'should match job_id' do
			expect(@candidate_job_action.job_id).to eq(job.id)
		end

		it 'should have is_saved value false' do
			expect(@candidate_job_action.is_saved).to eq(false)
		end

		it 'should not have is_saved value true' do
			expect(@candidate_job_action.is_saved).not_to eq(true)
		end
	end

	context 'can_proceed. archetype_score value' do
		it 'can return nil' do
			candidate.archetype_score = nil
			expect(candidate.archetype_score).to be(nil)
		end

		it 'should return integer' do
			candidate.archetype_score = 30
			expect(candidate.archetype_score).to be_kind_of(Integer)
			expect(candidate.archetype_score).to be_instance_of(Fixnum)
		end
	end

	context 'archetype_string.' do
		it 'should return n/a' do
		  candidate.archetype_score = nil
			expect(candidate.archetype_string).to eq('n/a')
		end

		it 'should return Aggressive Hunter' do
		  candidate.archetype_score = 75
			expect(candidate.archetype_string).to eq('Aggressive Hunter')
		end

		it 'should return Relaxed Hunter' do
		  candidate.archetype_score = 40
			expect(candidate.archetype_string).to eq('Relaxed Hunter')
		end

		it 'should return Aggressive Fisherman' do
		  candidate.archetype_score = 25
			expect(candidate.archetype_string).to eq('Aggressive Fisherman')
		end

		it 'should return Balanced Fisherman' do
		  candidate.archetype_score = 2
			expect(candidate.archetype_string).to eq('Balanced Fisherman')
		end

		it 'should return Relaxed Fisherman' do
		  candidate.archetype_score = -25
			expect(candidate.archetype_string).to eq('Relaxed Fisherman')
		end

		it 'should return Aggressive Farmer' do
		  candidate.archetype_score = -60
			expect(candidate.archetype_string).to eq('Aggressive Farmer')
		end

		it 'should return Relaxed Farmer' do
		  candidate.archetype_score = -70
			expect(candidate.archetype_string).to eq('Relaxed Farmer')
		end
	end
end
