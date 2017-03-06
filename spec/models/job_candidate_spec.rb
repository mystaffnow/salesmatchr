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
    expect(JobCandidate.statuses).to eq({"submitted"=>0, "viewed"=>1, "accepted"=>2, "withdrawn"=>3, "shortlist"=>4, "deleted"=>5, "purposed"=>6})
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

  it "should save status 'purposed'" do
    job_candidate.update_attributes(status: 'purposed')
    expect(job_candidate.status).to eq("purposed")
  end

  it "should not save invalid status" do
    expect{job_candidate.update_attributes(status: 'invalid')}.to raise_error("'invalid' is not a valid status")
  end
end
