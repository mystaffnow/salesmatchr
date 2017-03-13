# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  employer_id      :integer
#  salary_low       :integer
#  salary_high      :integer
#  zip              :string
#  is_remote        :boolean
#  title            :string
#  description      :text
#  is_active        :boolean          default(FALSE)
#  view_count       :integer
#  state_id         :integer
#  city             :string
#  archetype_low    :integer
#  archetype_high   :integer
#  job_function_id  :integer
#  latitude         :float
#  longitude        :float
#  stripe_token     :string
#  experience_years :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Job do
  let(:state) {create(:state)}
  let(:employer) {create(:employer)}
  let(:job_function) {create(:job_function, name: 'test', low: -30, high: 70)}
  let(:job) {
      create(:job, employer_id: @employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: @state.id,
                    job_function_id: job_function.id
                    )
            }
  
  describe "Validation" do
    it {validate_presence_of :employer_id}
    it {validate_presence_of :title}
    it {validate_presence_of :description}
    it {validate_presence_of :city}
    it {validate_presence_of :zip}
  end

  describe "Association" do
    it {should belong_to :state}
    it {should belong_to :employer}
    it {should have_many(:job_candidates).dependent(:destroy)}
    it {should have_many(:candidate_job_actions).dependent(:destroy)}
    it {should belong_to :job_function}
    it {should have_one(:payment).dependent(:destroy)}
  end

  context 'matches.' do
    context '.Inside sales' do
      let(:inside_sales) {create(:inside_sales)} # low: 11, high: 100
      let(:inside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: inside_sales.id)}

      before do
        @candidate = create(:candidate, archetype_score: 11)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: 31)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: 50)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 80)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 100)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 101)
      end

      it 'should match candidates scale between 11-100' do
        expect(CandidateProfile.count).to eq(6)
        expect(inside_sales_job.matches).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Outside sales' do
      let(:outside_sales) {create(:outside_sales)} # low: 11, high: 100
      let(:outside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: outside_sales.id)}

      before do
        @candidate = create(:candidate, archetype_score: 11)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: 31)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: 50)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 80)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 100)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 101)
      end

      it 'should match candidates scale between 11-100' do
        expect(outside_sales_job.matches).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Business developement (bizdev)' do
      let(:business_developement) {create(:business_developement)} # low: -10, high: 70
      let(:business_developement_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: business_developement.id)}

      before do
        @candidate = create(:candidate, archetype_score: -20)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: -10)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: 10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 50)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 70)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 71)
      end

      it 'should match candidates scale between -10 to 70' do
        expect(business_developement_job.matches).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Sales Manager' do
      let(:sales_manager) {create(:sales_manager)} # low: -30, high: 70
      let(:sales_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_manager.id)}

      before do
        @candidate = create(:candidate, archetype_score: -40)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: -30)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 10)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 70)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 71)
      end

      it 'should match candidates scale between -30 to 70' do
        expect(sales_manager_job.matches).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Sales Operations' do
      let(:sales_operations) {create(:sales_operations)} # low: -100, high: 10
      let(:sales_operations_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_operations.id)}

      before do
        @candidate = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 1)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 10)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 11)
      end

      it 'should match candidates scale between -100 to 10' do
        expect(sales_operations_job.matches).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Customer service' do
      let(:customer_service) {create(:customer_service)} # low: -100, high: 10
      let(:customer_service_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: customer_service.id)}

      before do
        @candidate = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 1)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 10)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: 11)
      end

      it 'should match candidates scale between -100 to 10' do
        expect(customer_service_job.matches).to eq([@candidate4, @candidate1, @candidate2, @candidate3])
      end
    end

    context '.Account Manager' do
      let(:account_manager) {create(:account_manager)} # low: -100, high: -11
      let(:account_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: account_manager.id)}

      before do
        @candidate = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_incognito: false)
        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -50)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: -12)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: -11)
        CandidateProfile.fifth.update(is_incognito: false)
        @candidate5 = create(:candidate, archetype_score: -9)
      end

      it 'should match candidates scale between -100 to -11' do
        expect(account_manager_job.matches).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end
  end

  context 'applicants.' do
    before(:each) do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
        CandidateProfile.first.update(is_incognito: false)
      @candidate2 = create(:candidate, archetype_score: 22)
        CandidateProfile.second.update(is_incognito: false)
      @candidate3 = create(:candidate, archetype_score: 25)
        CandidateProfile.third.update(is_incognito: false)
      @candidate4 = create(:candidate, archetype_score: 30)
        CandidateProfile.fourth.update(is_incognito: false)
      @candidate5 = create(:candidate, archetype_score: 35)
        CandidateProfile.fifth.update(is_incognito: false)
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

  context 'shortlist' do
    before(:each) do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id, job_function_id: job_function.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 35)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate1.id, status: 4)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate2.id, status: 1)
    end

    it 'should return list of shortlist candidate' do
      expect(@job.shortlist).to eq([@candidate1])
    end
  end

  context 'deleted' do
    before(:each) do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id, job_function_id: job_function.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 35)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate1.id, status: 5)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate2.id, status: 1)
    end

    it 'should return list of shortlist candidate' do
      expect(@job.deleted).to eq([@candidate1])
    end
  end

  it 'full_street_address' do
    @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id, job_function_id: job_function.id
                    )
    
    expect(@job.full_street_address).to eq("city1 Alaska 10900")
  end

  describe '#send_email' do
    let(:inside_sales) {create(:inside_sales)} # low: 11, high: 100
    let(:inside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: inside_sales.id)}

    it 'should send email to matched candidates who have email subscription ON' do
      @candidate1 = create(:candidate, archetype_score: 11)
      CandidateProfile.first.update(is_active_match_subscription: false)
      @candidate2 = create(:candidate, archetype_score: 35)
      CandidateProfile.second.update(is_active_match_subscription: false)
      @candidate3 = create(:candidate, archetype_score: 90)
      CandidateProfile.third.update(is_active_match_subscription: true)

      expect(CandidateProfile.count).to eq(3)
      expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(1)
      expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(2)
      expect {inside_sales_job.send_email}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'should not send email to unmatched candidates' do
      @candidate1 = create(:candidate, archetype_score: -10)
      CandidateProfile.first.update(is_active_match_subscription: true)
      @candidate2 = create(:candidate, archetype_score: -10)
      CandidateProfile.second.update(is_active_match_subscription: true)
      
      expect {inside_sales_job.send_email}.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    it 'on success' do
      inside_sales_job.send_email
      expect(Job.count).to eq(1)
    end
  end
end
