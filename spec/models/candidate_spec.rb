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

	describe "Paperclip avatar" do
		it{ should accept_nested_attributes_for(:experiences).allow_destroy(true) }
    it{ should accept_nested_attributes_for(:educations).allow_destroy(true) }
    it{ should accept_nested_attributes_for(:candidate_question_answers).allow_destroy(true) }
	
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
end
