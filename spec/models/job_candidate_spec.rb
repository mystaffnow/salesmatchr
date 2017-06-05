# == Schema Information
#
# Table name: job_candidates
#
#  id           :integer          not null, primary key
#  candidate_id :integer
#  job_id       :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe JobCandidate do
  let(:job_candidate) {create(:job_candidate)}

  describe 'association' do
    it { should belong_to :job }
    it { should belong_to :candidate }
  end

  it 'should have enum status' do
    expect(JobCandidate.statuses).to eq({"submitted"=>0, "viewed"=>1, "accepted"=>2, "withdrawn"=>3, "shortlist"=>4, "deleted"=>5})
  end

  it "should save status 'submitted'" do
    job_candidate.update_attributes(status: 'submitted')
    expect(job_candidate.status).to eq("submitted")
  end

  it "should save status 'viewed'" do
    job_candidate.update_attributes(status: 'viewed')
    expect(job_candidate.status).to eq("viewed")
  end

  it "should save status 'accepted'" do
    job_candidate.update_attributes(status: 'accepted')
    expect(job_candidate.status).to eq("accepted")
  end

  it "should save status 'withdrawn'" do
    job_candidate.update_attributes(status: 'withdrawn')
    expect(job_candidate.status).to eq("withdrawn")
  end

  it "should save status 'shortlist'" do
    job_candidate.update_attributes(status: 'shortlist')
    expect(job_candidate.status).to eq("shortlist")
  end

  it "should save status 'deleted'" do
    job_candidate.update_attributes(status: 'deleted')
    expect(job_candidate.status).to eq("deleted")
  end

  it "should not save invalid status" do
    expect{job_candidate.update_attributes(status: 'invalid')}.to raise_error("'invalid' is not a valid status")
  end

  it "should have active_job_candidate_list" do
    job_function = create(:job_function)
    state = create(:state)
    job1 = create(:job, state_id: state.id, job_function_id: job_function.id, is_active: true, status: 0)
    candidate1 = create(:candidate)
    CandidateProfile.last.update(is_incognito: false)
    create(:job_candidate, candidate_id: candidate1.id, job_id: job1.id, status: 'submitted')

    job_function2 = create(:job_function, name: 'title test')
    state2 = create(:state, name: 'title test')
    job2 = create(:job, state_id: state2.id, job_function_id: job_function2.id, is_active: false, status: 1)
    create(:job_candidate, candidate_id: candidate1.id, job_id: job2.id, status: 'submitted')

    expect(JobCandidate.count).to eq(2)
    expect(JobCandidate.active_job_candidate_list(candidate1).count).to eq(1)
  end

  it "should have statuses_opened array" do
    expect(JobCandidate.statuses_opened).to eq([0, 1, 4, 2, 5])
  end

  context '#is_applicants?' do
    it '' do
      job_candidate.submitted!
      expect(job_candidate.status).to eq("submitted")
      expect(job_candidate.is_applicants?).to be_truthy
    end

    it '' do
      job_candidate.withdrawn!
      expect(job_candidate.status).to eq("withdrawn")
      expect(job_candidate.is_applicants?).to be_falsy
    end
  end
end
