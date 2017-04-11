require 'rails_helper'

RSpec.describe CandidateJobActionsController, :type => :controller do
  let(:candidate) {create(:candidate, archetype_score: 35)}
  let(:job_function) {create(:job_function)}
  let(:state) {create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:job) {create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id)}
  let(:candidate_job_action) {create(:candidate_job_action, candidate_id: candidate.id, job_id: job.id)}

  describe "#candidate_job_saved" do
    it '.when archetype_score is nil' do
      @candidate3 = create(:candidate, archetype_score: nil)
      sign_in(@candidate3)
      get :candidate_job_saved
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before{ sign_in(candidate) }

      it 'should return candidate jobs saved list' do
        state2 = create(:state, name: 'Test2')
        state3 = create(:state, name: 'Test3')
        state4 = create(:state, name: 'Test4')
        job1 = job
        job2 = create(:job, state_id: state2.id, is_active: true, status: Job.statuses["enable"])
        job3 = create(:job, state_id: state3.id, is_active: true, status: Job.statuses["enable"])
        job4 = create(:job, state_id: state4.id, is_active: true, status: Job.statuses["enable"])
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job1.id, is_saved: true)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job2.id, is_saved: true)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job3.id, is_saved: true)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job4.id, is_saved: false)
        get :candidate_job_saved
        expect(assigns(:jobs)).to eq([job2, job3])
        expect(assigns(:jobs)).not_to eq([job, job4]) # job is inactive and job4 is not saved just viewed
      end

      it 'should assign max 25 records on variable' do
        30.times do |i|
          state = create(:state, name: "State #{i}")
          job = create(:job, state_id: state.id, is_active: true, status: Job.statuses["enable"])
          create(:candidate_job_action, candidate_id: candidate.id, job_id: job.id, is_saved: true)
        end
        get :candidate_job_saved
        expect(CandidateJobAction.count).to eq(30)
        expect(assigns(:jobs)).to eq(Job.first(25))
      end
    end

    context '.when employer is signed_in' do
      before{
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :candidate_job_saved
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe "#candidate_job_viewed" do
    it '.when archetype_score is nil' do
      @candidate3 = create(:candidate, archetype_score: nil)
      sign_in(@candidate3)
      get :candidate_job_viewed
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before{ sign_in(candidate) }

      it 'should return candidate job viewed list' do
        state2 = create(:state, name: 'Test2')
        state3 = create(:state, name: 'Test3')
        state4 = create(:state, name: 'Test4')
        job1 = job
        job2 = create(:job, state_id: state2.id, is_active: true, status: Job.statuses["enable"])
        job3 = create(:job, state_id: state3.id, is_active: true, status: Job.statuses["enable"])
        job4 = create(:job, state_id: state4.id, is_active: true, status: Job.statuses["enable"])
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job1.id, is_saved: true)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job2.id, is_saved: false)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job3.id, is_saved: false)
        create(:candidate_job_action, candidate_id: candidate.id, job_id: job4.id, is_saved: false)
        get :candidate_job_viewed
        expect(assigns(:jobs)).to eq([job4, job3, job2])
        expect(assigns(:jobs)).not_to eq([job1])
      end

      it 'should assign max 25 records on variable' do
        30.times do |i|
          state = create(:state, name: "State #{i}")
          job = create(:job, state_id: state.id, is_active: true, status: Job.statuses["enable"])
          create(:candidate_job_action, candidate_id: candidate.id, job_id: job.id, is_saved: false)
        end
        get :candidate_job_viewed
        expect(CandidateJobAction.count).to eq(30)
        expect(assigns(:jobs)).to eq(Job.order('id desc').first(25))
      end
    end

    context '.when employer is signed_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :candidate_job_viewed 
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe "#candidate_matches" do
    it '.when archetype_score is nil' do
      @candidate3 = create(:candidate, archetype_score: nil)
      sign_in(@candidate3)
      get :candidate_matches
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before{
        sign_in(candidate) 
      }

      it 'should return active-job matches list for the candidate' do
        job.update_attributes(is_active: true)
        job.reload
        state1 = create(:state, name: 'Test1')
        state2 = create(:state, name: 'Test2')
        state3 = create(:state, name: 'Test3')
        job1 = create(:job, state_id: state1.id, job_function_id: job_function.id, is_active: true)
        job2 = create(:job, state_id: state2.id, job_function_id: job_function.id, is_active: true)
        job3 = create(:job, state_id: state3.id, job_function_id: job_function.id, is_active: false)
        get :candidate_matches
        expect(assigns(:jobs)).to eq([job, job1, job2])
      end

      context '.archetype_score' do
        let(:candidate) { create(:candidate, archetype_score: 35)}

        let(:inside_sales) {create(:inside_sales)}                      # low: 31, high: 100
        let(:outside_sales) {create(:outside_sales)}                    # low: 31, high: 100
        let(:business_developement) {create(:business_developement)}    # low: -10, high: 70
        let(:sales_manager) {create(:sales_manager)}                    # low: -30, high: 70
        let(:sales_operations) {create(:sales_operations)}              # low: -100, high: 10
        let(:customer_service) {create(:customer_service)}              # low: -100, high: 10
        let(:account_manager) {create(:account_manager)}                # low: -100, high: -11

        before do
          @job  = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: inside_sales.id)
          @job1 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: outside_sales.id)
          @job2 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: business_developement.id)
          @job3 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: sales_manager.id)
          @job4 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: sales_operations.id)
          @job5 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: customer_service.id)
          @job6 = create(:job, is_active: true, state_id: state.id, employer_id: employer.id, job_function_id: account_manager.id)
        end

        it 'should match candidates scale between 31-100' do
          get :candidate_matches
          expect(assigns(:jobs)).to eq([@job, @job1, @job2, @job3])
        end
      end


      it 'should assign max 25 records on variable' do
        @inside_sales1 = create(:inside_sales) 
        30.times do |i|
          state = create(:state, name: "State #{i}")
          job = create(:job, state_id: state.id, is_active: true, employer_id: employer.id, job_function_id: @inside_sales1.id)
        end
        get :candidate_matches
        expect(Job.count).to eq(30)
        expect(assigns(:jobs)).to eq(Job.first(25))
      end
    end

    context '.when employer is signed_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'redirects to candidates login page' do
        get :candidate_matches
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#candidate_save_job' do
    it '.when archetype_score is nil' do
      @candidate3 = create(:candidate, archetype_score: nil)
      sign_in(@candidate3)
      post :candidate_save_job, job_id: job.id
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before do
        sign_in(candidate)
        post :candidate_save_job, job_id: job.id
      end

      it { expect(assigns(:candidate_job_action)).to eq(CandidateJobAction.last) }
      it { expect(response).to redirect_to(candidate_matches_path) }
      it { expect(CandidateJobAction.count).to eq(1) }
      it { expect(CandidateJobAction.last.candidate_id).to eq(candidate.id) }
      it { expect(CandidateJobAction.last.is_saved).to be_truthy }
    end

    context '.when candidate1 is signed_in' do
      before do
        @candidate1 = create(:candidate, archetype_score: 50)
        sign_in(@candidate1)
        post :candidate_save_job, job_id: job.id  
      end

      it { expect(assigns(:candidate_job_action)).to eq(CandidateJobAction.last) }
      it { expect(response).to redirect_to(candidate_matches_path) }
      it { expect(CandidateJobAction.count).to eq(1) }
      it { expect(CandidateJobAction.last.candidate_id).to eq(@candidate1.id) }
      it { expect(CandidateJobAction.last.is_saved).to be_truthy }
    end

    context '.when employer is signed_in' do
      before{
        employer_profile(employer)
        sign_in(employer) 
      }

      it 'redirects to candidates login page' do
        post :candidate_save_job, job_id: job.id
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end
end
