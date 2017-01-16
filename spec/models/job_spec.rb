require 'rails_helper'

RSpec.describe Job do
  let(:state) {create(:state)}
  let(:employer) {create(:employer)}
  let(:job) {
      create(:job, employer_id: @employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: @state.id
                    )
            }
  describe "Association" do
    it {should belong_to :state}
    it {should belong_to :employer}
    it {should have_many :job_candidates}
    it {should have_many :candidate_job_actions}
  end

  context 'matches.' do
    before(:each) do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 35)
    end

    it 'should return array of candidates' do
      expect(@job.matches).to eq([@candidate1, @candidate2])
    end
  end

  context 'applicants.' do
    before(:each) do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 22)
      @candidate3 = create(:candidate, archetype_score: 25)
      @candidate4 = create(:candidate, archetype_score: 30)
      @candidate5 = create(:candidate, archetype_score: 35)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate1.id, status: 0)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate2.id, status: 1)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate3.id, status: 2)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate4.id, status: 3)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate5.id, status: 6)
    
      it 'should return list of candidates, when job_candidate status is not deleted/shortlisted' do
        expect(@job.applicants).to eq([@candidate1, @candidate2, @candidate3, @candidate4, @candidate5])
      end
    end
  end
end