# == Schema Information
#
# Table name: candidates
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  city                   :string
#  state_id               :integer
#  zip                    :string
#  education_level_id     :integer
#  archetype_score        :integer
#  ziggeo_token           :string
#  uid                    :string
#  provider               :string
#  is_incognito           :boolean
#  year_experience_id     :integer
#  linkedin_picture_url   :string
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
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

require 'rails_helper'

RSpec.describe Candidate do
	let(:employer) {create(:employer, :first_name => "test", :last_name => "employer")}
	let(:state) {create(:state)}
	let(:job) {create(:job, employer_id: employer.id, state_id: state.id, city: 'New york', zip: 10900)}
	let(:candidate) {create(:candidate, :first_name => "test", :last_name => "candidate")}

	describe "Association" do
		it {should have_many :experiences}
		it {should have_many :educations}
		it {should have_many :candidate_question_answers}
		it {should have_many :job_candidates}
		it {should belong_to :state}
		it {should belong_to :education_level}
		it {should belong_to :year_experience}
	end

	context 'nested attributes' do
		it{ should accept_nested_attributes_for(:experiences).allow_destroy(true) }
		it{ should accept_nested_attributes_for(:educations).allow_destroy(true) }
		it{ should accept_nested_attributes_for(:candidate_question_answers).allow_destroy(true) }
	end

	describe "Paperclip avatar" do
		it { should have_attached_file(:avatar) }
	  # it { should validate_attachment_presence(:avatar) }
	  it { should validate_attachment_content_type(:avatar).
	  	allowing('image/jpg', 'image/png', 'image/gif').
	  	rejecting('text/plain', 'text/xml') }
	  # it { should validate_attachment_size(:avatar).less_than(1.megabytes) }
	  
	  context '.shoulda matcher' do
	  	it 'should return default avatar' do
	  		expect(candidate.avatar_url).to eq('/img/missing.png')
	  	end
	  end
	end
	
	context 'name' do
		it 'should return full_name of candidate' do
			expect(candidate.name).to eq('test candidate')
		end
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

		it 'should equals purposed' do
			@job_candidate.status = 6
			expect(@job_candidate.status).to eq("purposed")
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

	context 'password_required?' do
		it 'should return false' do
			candidate.provider = 'linkedin'
			expect(candidate.password_required?).to eq(false)
		end

		it 'should return true' do
			candidate.provider = nil
			expect(candidate.password_required?).to eq(true)
		end
	end

	context 'email_required?' do
		it 'should return false' do
			candidate.provider = 'linkedin'
			expect(candidate.email_required?).to eq(false)
		end

		it 'should return true' do
			candidate.provider = nil
			expect(candidate.email_required?).to eq(true)
		end
	end

	context 'avatar_url.' do
		before(:each) do
			@path = File.open("#{Rails.root}/public/img/incognito.png", "rb+")
			@candidate = create(:candidate, :first_name => "test", :last_name => "candidate", avatar: @path )
		end

		it 'should display incognito.png' do
			candidate.is_incognito = true
			expect(@candidate.avatar_url).to match(/incognito.png/)
		end

		it 'should display missing.png' do
			candidate.is_incognito = nil
			expect(candidate.avatar_url).to eq("/img/missing.png")
		end
		
		it 'should display profile.jpg' do
			candidate.is_incognito = false
		  candidate.linkedin_picture_url = "profile.jpg"
			expect(candidate.avatar_url).to eq("profile.jpg")
		end

		it 'should display incognito.png' do
			candidate.is_incognito = false
			candidate.linkedin_picture_url = nil
			expect(@candidate.avatar_url).to match(/incognito.png/)
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
