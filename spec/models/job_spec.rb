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
#  status           :integer          default(0)
#  is_active        :boolean          default(TRUE)
#  activated_at     :datetime
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

  it 'should have enum status' do
    expect(Job.statuses).to eq({"enable"=>0, "disable"=>1})
  end

  it '#add_archetype_score .assign job function value to archetype scale' do
    @job_function = create(:job_function)
    @job = create(:job, job_function_id: @job_function.id)
    expect(Job.count).to eq(1)
    expect(Job.first.archetype_low).to eq(@job.job_function.low)
    expect(Job.first.archetype_high).to eq(@job.job_function.high)
  end

  context '#job_matched_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.job_matched_list(@candidate)).to eq([])
    end

    it 'should return job list which are active & matched to candidate' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id)

      @job_function1 = create(:outside_sales)
      @state1 = create(:state, name: 'Test')
      @job2 = create(:job, job_function_id: @job_function1.id, state_id: @state1.id, is_active: false)
      expect(Job.job_matched_list(@candidate)).to eq([@job1])
    end

    it 'should return nil when job is inactive and disabled' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["disable"])
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id)
      expect(Job.job_matched_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('disable')
      expect(Job.job_matched_list(@candidate)).not_to eq([@job1])
    end
  end

  context '#job_viewed_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.job_viewed_list(@candidate)).to eq([])
    end

    it 'should return jobs list' do
      @job = create(:job)
      @candidate = create(:candidate)
      @candidate_job_action = create(:candidate_job_action, job_id: @job.id, candidate_id: @candidate.id)
      expect(Job.job_viewed_list(@candidate)).to eq([@job])
    end

    it 'should return nil when job is inactive and disabled' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["disable"])
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id)
      expect(Job.job_matched_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('disable')
      expect(Job.job_viewed_list(@candidate)).not_to eq([@job1])
    end
  end

  context '#job_saved_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.job_saved_list(@candidate)).to eq([])
    end

    it 'should return jobs list' do
      @job_function = create(:inside_sales)
      @job = create(:job, job_function_id: @job_function.id)

      @job_function1 = create(:outside_sales)
      @state1 = create(:state, name: 'Test')
      @job1 = create(:job, job_function_id: @job_function1.id, state_id: @state1.id)
      
      @candidate = create(:candidate)
      
      @candidate_job_action1 = create(:candidate_job_action, job_id: @job.id,
                                                           candidate_id: @candidate.id,
                                                           is_saved: true)
      @candidate_job_action2 = create(:candidate_job_action, job_id: @job1 .id,
                                                           candidate_id: @candidate.id,
                                                           is_saved: false)
      expect(Job.job_saved_list(@candidate)).to eq([@job])
    end

    it 'should return nil when job is inactive and disabled' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["disable"])
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id)
      expect(Job.job_matched_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('disable')
      expect(Job.job_saved_list(@candidate)).not_to eq([@job1])
    end
  end

  context '#visible_candidate_viewed_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.visible_candidate_viewed_list(@candidate)).to eq([])
    end

    it 'should return candidates list' do
      @job = create(:job)
      @candidate = create(:candidate)
      CandidateProfile.first.update_attribute(:is_incognito, false)
      @candidate1 = create(:candidate) # incognito ON
      @candidate2 = create(:candidate)
      CandidateProfile.third.update_attribute(:is_incognito, false)
      @candidate_job_action1 = create(:candidate_job_action, job_id: @job.id,
                                                           candidate_id: @candidate.id,
                                                           is_saved: true)
      @candidate_job_action2 = create(:candidate_job_action, job_id: @job.id,
                                                           candidate_id: @candidate2.id,
                                                           is_saved: true)
      expect(Job.visible_candidate_viewed_list(@job)).to eq([@candidate, @candidate2])
    end
  end

  describe '#candidate_matches_list' do
    context '.Inside sales' do
      let(:inside_sales) {create(:inside_sales)} # low: 11, high: 100
      let(:inside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: inside_sales.id)}

      it 'should match candidates scale between 11-100' do
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

        expect(CandidateProfile.count).to eq(6)
        expect(inside_sales_job.candidate_matches_list).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Outside sales' do
      let(:outside_sales) {create(:outside_sales)} # low: 11, high: 100
      let(:outside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: outside_sales.id)}

      it 'should match candidates scale between 11-100' do
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

        expect(outside_sales_job.candidate_matches_list).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Business developement (bizdev)' do
      let(:business_developement) {create(:business_developement)} # low: -10, high: 70
      let(:business_developement_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: business_developement.id)}

      it 'should match candidates scale between -10 to 70' do
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

        expect(business_developement_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Sales Manager' do
      let(:sales_manager) {create(:sales_manager)} # low: -30, high: 70
      let(:sales_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_manager.id)}

      it 'should match candidates scale between -30 to 70' do
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

        expect(sales_manager_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Sales Operations' do
      let(:sales_operations) {create(:sales_operations)} # low: -100, high: 10
      let(:sales_operations_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_operations.id)}

      it 'should match candidates scale between -100 to 10' do
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

        expect(sales_operations_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Customer service' do
      let(:customer_service) {create(:customer_service)} # low: -100, high: 10
      let(:customer_service_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: customer_service.id)}

      it 'should match candidates scale between -100 to 10' do
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

        expect(customer_service_job.candidate_matches_list.count).to eq(4)
        expect(customer_service_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end

    context '.Account Manager' do
      let(:account_manager) {create(:account_manager)} # low: -100, high: -11
      let(:account_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: account_manager.id)}

      it 'should match candidates scale between -100 to -11' do
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

        expect(account_manager_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
      end
    end
  end

  context 'applicants.' do
    it 'should return list of candidates, when job_candidate status is not deleted/shortlisted' do
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
        
      expect(@job.applicants).to eq([@candidate1, @candidate2, @candidate3, @candidate4, @candidate5])
    end
  end

  context 'shortlist' do
    it 'should return list of shortlist candidate' do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id, job_function_id: job_function.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 35)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate1.id, status: 4)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate2.id, status: 1)

      expect(@job.shortlist).to eq([@candidate1])
    end
  end

  context 'deleted' do
    it 'should return list of shortlist candidate' do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id, job_function_id: job_function.id
                    )
      @candidate1 = create(:candidate, archetype_score: 21)
      @candidate2 = create(:candidate, archetype_score: 35)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate1.id, status: 5)
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate2.id, status: 1)

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

    it 'should return status 0 when success' do
      expect(inside_sales_job.send_email).to eq(0)
    end

    it 'should not return status 500 when success' do
      expect(inside_sales_job.send_email).not_to eq(500)
    end

    it 'on success' do
      inside_sales_job.send_email
      expect(Job.count).to eq(1)
    end
  end

  # Test query for expired_jobs
  # jobs are expired after 30 days of activated time
  # context '#expired_jobs' do
  #   it 'should return all expired jobs' do
  #     @job = create(:job, activated_at: 2.days.ago, state_id: state.id, employer: employer, job_function: job_function)
  #     @job1 = create(:job, activated_at: 29.days.ago, state_id: state.id, employer: employer, job_function: job_function)
  #     @job2 = create(:job, activated_at: 30.days.ago, state_id: state.id, employer: employer, job_function: job_function)
  #     @job3 = create(:job, activated_at: 31.days.ago, state_id: state.id, employer: employer, job_function: job_function)

  #     expect(Job.expired_jobs).to eq([@job2, @job3])
  #   end
  # end
end
