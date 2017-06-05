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
#  state_id         :integer
#  city             :string
#  archetype_low    :integer
#  archetype_high   :integer
#  job_function_id  :integer
#  latitude         :float
#  longitude        :float
#  experience_years :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer          default(0)
#  is_active        :boolean          default(FALSE)
#  activated_at     :datetime
#

require 'rails_helper'

RSpec.describe Job do
  let(:state) {create(:state)}
  let(:employer) {create(:employer)}
  let(:job_function) {create(:job_function, name: 'test', low: -30, high: 70)}
  let(:job) {
      create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id,
                    job_function_id: job_function.id, experience_years: 10
                    )
            }
  
  describe "Validation" do
    it {validate_presence_of :employer_id}
    it {validate_presence_of :title}
    it {validate_presence_of :description}
    it {validate_presence_of :city}
    it {validate_presence_of :zip}
    it {validate_presence_of :job_function_id}
    it {validate_presence_of :experience_years}
  end

  describe "Association" do
    it {should belong_to :state}
    it {should belong_to :employer}
    it {should have_many(:job_candidates).dependent(:destroy)}
    it {should have_many(:candidate_job_actions).dependent(:destroy)}
    it {should belong_to :job_function}
    it {should have_many(:payments).dependent(:destroy)}
  end

  it 'should have enum status' do
    expect(Job.statuses).to eq({"enable"=>0, "expired"=>1})
  end

  it '#add_archetype_score .assign job function value to archetype scale' do
    @job_function = create(:job_function)
    @job = create(:job, job_function_id: @job_function.id)
    expect(Job.count).to eq(1)
    expect(Job.first.archetype_low).to eq(@job.job_function.low)
    expect(Job.first.archetype_high).to eq(@job.job_function.high)
  end

  describe '#add_activated_at' do
    it '.when job is saved, activated_at should auto save' do
      job
      expect(Job.count).to eq(1)
      expect(Job.first.activated_at).not_to be_nil
    end

    it '.when job is updated, activated_at should not auto update until some value is passed' do
      job
      Job.first.update(activated_at: nil)
      expect(Job.count).to eq(1)
      expect(Job.first.activated_at).to be_nil

      Job.first.update(title: 'test title', description: 'test description')
      expect(Job.first.activated_at).to be_nil
      
      Job.first.update(title: 'old title', description: 'old description', activated_at: DateTime.now)
      expect(Job.first.activated_at).not_to be_nil
    end
  end

  context '#job_matched_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.job_matched_list(@candidate)).to eq([])
    end

    it 'should return job list which are active & matched to candidate' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: true, status: Job.statuses["enable"])

      @job_function1 = create(:outside_sales)
      @state1 = create(:state, name: 'Test')
      @job2 = create(:job, job_function_id: @job_function1.id, state_id: @state1.id, is_active: false, status: Job.statuses["enable"])
      expect(Job.job_matched_list(@candidate)).to eq([@job1])
    end

    it 'should return nil when job is inactive and disabled' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["expired"])
      
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id, is_active: true, status: Job.statuses["enable"])
      
      expect(Job.job_matched_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('expired')
      expect(Job.job_matched_list(@candidate)).not_to eq([@job1])
    end
  end

  context '#job_viewed_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.job_viewed_list(@candidate)).to eq([])
    end

    it 'should return jobs list' do
      @job1 = create(:job, job_function_id: job_function.id, is_active: false, status: Job.statuses["enable"])
      @candidate = create(:candidate)
      @candidate_job_action = create(:candidate_job_action, job_id: @job1.id, candidate_id: @candidate.id)
      
      @inside_sales = create(:inside_sales)
      @state1 = create(:state, name: 'Title 11')
      @job2 = create(:job, state_id: @state1.id, job_function_id: @inside_sales.id, is_active: true, status: Job.statuses["expired"])
      @candidate_job_action = create(:candidate_job_action, job_id: @job2.id, candidate_id: @candidate.id)

      @outside_sales = create(:inside_sales, name: 'job function1')
      @state2 = create(:state, name: 'Title 21')
      @job3 = create(:job, state_id: @state2.id, job_function_id: @outside_sales.id, is_active: true, status: Job.statuses["enable"])
      @candidate_job_action = create(:candidate_job_action, job_id: @job3.id, candidate_id: @candidate.id)

      expect(Job.count).to eq(3)
      expect(Job.job_viewed_list(@candidate)).to eq([@job3])
    end

    it 'should return nil when job is inactive and expired' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["expired"])
      @candidate_job_action = create(:candidate_job_action, job_id: @job1.id, candidate_id: @candidate.id)
      
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id, is_active: true, status: Job.statuses["enable"])
      @candidate_job_action = create(:candidate_job_action, job_id: @job.id, candidate_id: @candidate.id)
      
      expect(Job.count).to eq(2)
      expect(Job.job_viewed_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('expired')
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
      @job = create(:job, job_function_id: @job_function.id, is_active: true, status: Job.statuses["enable"])

      @job_function1 = create(:outside_sales)
      @state1 = create(:state, name: 'Test')
      @job1 = create(:job, job_function_id: @job_function1.id, state_id: @state1.id, is_active: false, status: Job.statuses["disable"])
      
      @candidate = create(:candidate)
      @candidate1 = create(:candidate)
      
      @candidate_job_action1 = create(:candidate_job_action, job_id: @job.id,
                                                           candidate_id: @candidate.id,
                                                           is_saved: true)
      @candidate_job_action2 = create(:candidate_job_action, job_id: @job1.id,
                                                           candidate_id: @candidate1.id)
      expect(Job.job_saved_list(@candidate)).to eq([@job])
    end

    it 'should return nil when job is inactive and expired' do
      @inside_sales = create(:inside_sales)
      @candidate = create(:candidate, archetype_score: 35)
      @job1 = create(:job, job_function_id: @inside_sales.id, is_active: false, status: Job.statuses["expired"])
      
      state = create(:state, name: 'Title 1')
      @job = create(:job, state_id: state.id, job_function_id: @inside_sales.id, is_active: true, status: Job.statuses["enable"])
      
      expect(Job.job_matched_list(@candidate)).to eq([@job])
      expect(Job.first.is_active).to be_falsy
      expect(Job.first.status).to eq('expired')
      expect(Job.job_saved_list(@candidate)).not_to eq([@job1])
    end
  end

  context '#visible_candidate_viewed_list' do
    it 'should return nil' do
      @candidate = create(:candidate)
      expect(Job.visible_candidate_viewed_list(@candidate)).to eq([])
    end

    it 'should return candidates list' do
      @job = create(:job, job_function_id: job_function.id)
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

  # This test case ensure, it correctly returning the job's candidate matches list for each job function
  # criteria: candidate profile should be visible to get matched to any job
  # criteria: candidate's archetype score should lies on the job archtype scale
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

        @candidate6 = create(:candidate, archetype_score: 101) # not lies on the scale
        CandidateProfile.order("id asc").offset(5).limit(1).first.update(is_incognito: false)
        
        @candidate7 = create(:candidate, archetype_score: 10) # not lies on the scale
        CandidateProfile.order("id asc").offset(6).limit(1).first.update(is_incognito: false)

        @candidate8 = create(:candidate, archetype_score: 11) # profile is hidden
        CandidateProfile.order("id asc").offset(7).limit(1).first.update(is_incognito: true)


        expect(CandidateProfile.count).to eq(8)
        expect(inside_sales_job.candidate_matches_list).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
        expect(inside_sales_job.candidate_matches_list).not_to eq([@candidate6, @candidate7, @candidate8])
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

        @candidate6 = create(:candidate, archetype_score: 101) # not lies on the scale
        CandidateProfile.order("id asc").offset(5).limit(1).first.update(is_incognito: false)
        
        @candidate7 = create(:candidate, archetype_score: 10) # not lies on the scale
        CandidateProfile.order("id asc").offset(6).limit(1).first.update(is_incognito: false)

        @candidate8 = create(:candidate, archetype_score: 11) # profile is hidden
        CandidateProfile.order("id asc").offset(7).limit(1).first.update(is_incognito: true)

        expect(outside_sales_job.candidate_matches_list).to eq([@candidate, @candidate1, @candidate2, @candidate3, @candidate4])
        expect(outside_sales_job.candidate_matches_list).not_to eq([@candidate6, @candidate7, @candidate8])
      end
    end

    context '.Business developement (bizdev)' do
      let(:business_developement) {create(:business_developement)} # low: -10, high: 70
      let(:business_developement_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: business_developement.id)}

      it 'should match candidates scale between -10 to 70' do
        @candidate = create(:candidate, archetype_score: -20) # score not lies on the scale
        CandidateProfile.first.update(is_incognito: false)

        @candidate1 = create(:candidate, archetype_score: -10)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: 10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 50)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 70)
        CandidateProfile.fifth.update(is_incognito: false)

        @candidate5 = create(:candidate, archetype_score: 71) # score not lies on the scale
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: false)

        @candidate6 = create(:candidate, archetype_score: 50) # score lies on the scale but profile is hidden
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: true)

        expect(business_developement_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
        expect(business_developement_job.candidate_matches_list).not_to eq([@candidate, @candidate5, @candidate6])
      end
    end

    context '.Sales Manager' do
      let(:sales_manager) {create(:sales_manager)} # low: -30, high: 70
      let(:sales_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_manager.id)}

      it 'should match candidates scale between -30 to 70' do
        @candidate = create(:candidate, archetype_score: -40) # score not lies on the scale
        CandidateProfile.first.update(is_incognito: false)

        @candidate1 = create(:candidate, archetype_score: -30)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 10)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 70)
        CandidateProfile.fifth.update(is_incognito: false)

        @candidate5 = create(:candidate, archetype_score: 71) # score not lies on the scale
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: false)

        @candidate6 = create(:candidate, archetype_score: 60) # score lies on the scale but profile is hidden
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_incognito: true)

        expect(sales_manager_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
        expect(sales_manager_job.candidate_matches_list).not_to eq([@candidate, @candidate5, @candidate6])
      end
    end

    context '.Sales Operations' do
      let(:sales_operations) {create(:sales_operations)} # low: -100, high: 10
      let(:sales_operations_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_operations.id)}

      it 'should match candidates scale between -100 to 10' do
        @candidate = create(:candidate, archetype_score: -110) # not lies on the scale
        CandidateProfile.first.update(is_incognito: false)

        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 1)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 10)
        CandidateProfile.fifth.update(is_incognito: false)

        @candidate5 = create(:candidate, archetype_score: 11) # score not lies on the scale
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: false)

        @candidate6 = create(:candidate, archetype_score: 5) # score lies on the scale but profile is hidden
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_incognito: true)


        expect(sales_operations_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
        expect(sales_operations_job.candidate_matches_list).not_to eq([@candidate, @candidate5, @candidate6])
      end
    end

    context '.Customer service' do
      let(:customer_service) {create(:customer_service)} # low: -100, high: 10
      let(:customer_service_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: customer_service.id)}

      it 'should match candidates scale between -100 to 10' do
        @candidate = create(:candidate, archetype_score: -110) # score not lies on the scale
        CandidateProfile.first.update(is_incognito: false)

        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -10)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: 1)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: 10)
        CandidateProfile.fifth.update(is_incognito: false)

        @candidate5 = create(:candidate, archetype_score: 11) # score not lies on the scale
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: false)

        @candidate6 = create(:candidate, archetype_score: 5) # score lies on the scale but profile is hidden
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_incognito: true)

        expect(customer_service_job.candidate_matches_list.count).to eq(4)
        expect(customer_service_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
        expect(customer_service_job.candidate_matches_list).not_to eq([@candidate, @candidate5, @candidate6])
      end
    end

    context '.Account Manager' do
      let(:account_manager) {create(:account_manager)} # low: -100, high: -11
      let(:account_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: account_manager.id)}

      it 'should match candidates scale between -100 to -11' do
        @candidate = create(:candidate, archetype_score: -110) # score not lies on the scale
        CandidateProfile.first.update(is_incognito: false)

        @candidate1 = create(:candidate, archetype_score: -100)
        CandidateProfile.second.update(is_incognito: false)
        @candidate2 = create(:candidate, archetype_score: -50)
        CandidateProfile.third.update(is_incognito: false)
        @candidate3 = create(:candidate, archetype_score: -12)
        CandidateProfile.fourth.update(is_incognito: false)
        @candidate4 = create(:candidate, archetype_score: -11)
        CandidateProfile.fifth.update(is_incognito: false)

        @candidate5 = create(:candidate, archetype_score: -7) # score not lies on the scale
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_incognito: false)

        @candidate6 = create(:candidate, archetype_score: -15) # score lies on the scale but profile is hidden
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_incognito: true)

        expect(account_manager_job.candidate_matches_list).to eq([@candidate1, @candidate2, @candidate3, @candidate4])
        expect(account_manager_job.candidate_matches_list).not_to eq([@candidate, @candidate5, @candidate6])
      end
    end
  end

  context 'applicants.' do
    it 'should return list of candidates, when job_candidate status is not deleted/shortlisted' do
      @job = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id,
                    job_function_id: job_function.id
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
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate5.id, status: 1)
        
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

  # This test case ensure email are sending only to matched candidates.
  # criteria: All candidates whose archetype score falls on this job's archetype scale &&
  # who have subscribe to receive our matched alert are called matched candidates to receive matched alert
  describe '#send_email_to_matched_candidates' do
    context "When job's function is inside_sales" do
      # if job function is inside sale
      let(:inside_sales) {create(:inside_sales)} # low: 11, high: 100
      let(:inside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: inside_sales.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: 11) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 35) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: 90) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 34) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 100) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 11) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: 101) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: -10) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {inside_sales_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -10)
        CandidateProfile.first.update(is_active_match_subscription: true)
        @candidate2 = create(:candidate, archetype_score: -0)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {inside_sales_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      it 'job matched alert should not work for expired job' do
        inside_sales_job.update(status: Job.statuses['expired'])
        @candidate8 = create(:candidate, archetype_score: 35) # no alert
        CandidateProfile.first.update(is_active_match_subscription: true)
        expect {inside_sales_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      it 'should return status 0 when success' do
        expect(inside_sales_job.send_email_to_matched_candidates).to eq(0)
      end

      it 'should not return status 500 when success' do
        expect(inside_sales_job.send_email_to_matched_candidates).not_to eq(500)
      end

      it 'on success' do
        inside_sales_job.send_email_to_matched_candidates
        expect(Job.count).to eq(1)
      end
    end

    context "when job's function is outside_sales" do
      let(:outside_sales) {create(:outside_sales)} # low: 11, high: 100
      let(:outside_sales_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: outside_sales.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: 11) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 35) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: 90) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 34) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 100) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 11) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: 101) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: -10) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {outside_sales_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -10)
        CandidateProfile.first.update(is_active_match_subscription: true)
        @candidate2 = create(:candidate, archetype_score: -0)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {outside_sales_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when job's function is Bizdiv" do
      let(:business_developement) {create(:business_developement)} # low: -10, high: 70
      let(:business_developement_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: business_developement.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: -10) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 10) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: -10) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 70) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 0) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 20) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: 75) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: -20) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {business_developement_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -15)
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 80)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {business_developement_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when job's function is SalesManager" do
      let(:sales_manager) {create(:sales_manager)} # low: -30, high: 70
      let(:sales_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_manager.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: -30) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 10) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: -30) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 70) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 0) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 20) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: 75) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: -40) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {sales_manager_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -40)
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 80)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {sales_manager_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when job's function is SalesOperations" do
      let(:sales_operations) {create(:sales_operations)} # low: -100, high: 10
      let(:sales_operations_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: sales_operations.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: -100) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 0) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: -100) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 0) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 10) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 5) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: -110) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: 20) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {sales_operations_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 20)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {sales_operations_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when job's function is Customer Service" do
      let(:customer_service) {create(:customer_service)} # low: -100, high: 10
      let(:customer_service_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: customer_service.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: -100) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 0) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: -100) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: 0) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: 10) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: 5) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: -110) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: 20) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {customer_service_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: 20)
        CandidateProfile.second.update(is_active_match_subscription: true)
        
        expect {customer_service_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when job's function is Account Manager" do
      let(:account_manager) {create(:account_manager)} # low: -100, high: -11
      let(:account_manager_job) {create(:job, state_id: state.id, employer_id: employer.id, job_function_id: account_manager.id, is_active: true, status: Job.statuses['enable'])}

      it 'should send email to matched candidates who have made email subscription ON' do
        @candidate1 = create(:candidate, archetype_score: -100) # matched but not subscribed
        CandidateProfile.first.update(is_active_match_subscription: false)
        @candidate2 = create(:candidate, archetype_score: -11) # matched but not subscribed
        CandidateProfile.second.update(is_active_match_subscription: false)

        @candidate3 = create(:candidate, archetype_score: -100) # matched & subscribed
        CandidateProfile.third.update(is_active_match_subscription: true)
        @candidate4 = create(:candidate, archetype_score: -50) # matched &  subscribed
        CandidateProfile.fourth.update(is_active_match_subscription: true)
        @candidate5 = create(:candidate, archetype_score: -65) # matched & subscribed
        CandidateProfile.fifth.update(is_active_match_subscription: true)
        @candidate6 = create(:candidate, archetype_score: -12) # matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: -110) # not matched & not subscribed
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: false)
        @candidate8 = create(:candidate, archetype_score: 0) # not matched & subscribed
        CandidateProfile.order("id asc").limit(1).offset(7).first.update(is_active_match_subscription: true)

        expect(CandidateProfile.count).to eq(8)
        expect(CandidateProfile.where(is_active_match_subscription: true).count).to eq(5)
        expect(CandidateProfile.where(is_active_match_subscription: false).count).to eq(3)
        expect {account_manager_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(4)
      end

      it 'should not send email to unmatched candidates' do
        @candidate1 = create(:candidate, archetype_score: -110)
        CandidateProfile.first.update(is_active_match_subscription: true)
        @candidate2 = create(:candidate, archetype_score: 0)
        CandidateProfile.second.update(is_active_match_subscription: false)
        
        expect {account_manager_job.send_email_to_matched_candidates}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
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
