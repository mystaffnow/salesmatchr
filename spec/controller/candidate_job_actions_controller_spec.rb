require 'rails_helper'

RSpec.describe CandidateJobActionsController, :type => :controller do
  let(:candidate) {create(:candidate, archetype_score: 200)}
  let(:job_function) {create(:job_function)}
  let(:state) {create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:employer_profile) {create(:employer_profile, employer_id: employer.id, state_id: state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org', )}
  let(:job) {create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id)}
  let(:candidate_job_action) {create(:candidate_job_action, candidate_id: candidate.id, job_id: job.id)}

  describe "#candidate_job_saved" do
    it '.when archetype_score is nil' do
      @candidate3 = create(:candidate, archetype_score: nil)
      sign_in(@candidate3)
      post :candidate_job_saved
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before{ sign_in(candidate) }

      it 'should assign @candidate_job_action' do
        candidate_job_action.update(is_saved: true)
        candidate_job_action.reload
        get :candidate_job_saved
        expect(assigns(:candidate_job_action)).to eq([candidate_job_action])
      end
    end

    context '.when employer is signed_in' do
      before{ 
        employer_profile
        sign_in(employer) 
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
      post :candidate_job_viewed
      expect(response).to redirect_to(candidates_archetype_path)
    end

    context '.when candidate is signed_in' do
      before{ sign_in(candidate) }

      it 'should assign @candidate_job_action' do
        get :candidate_job_viewed
        expect(assigns(:candidate_job_action)).to eq([candidate_job_action])
      end
    end

    context '.when employer is signed_in' do
      before{ 
        employer_profile
        sign_in(employer) 
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
      before{ sign_in(candidate) }

      it 'should assign @jobs' do
        job.update_attributes(archetype_low: 10, archetype_high: 201, is_active: true)
        job.reload
        get :candidate_matches
        expect(assigns(:jobs)).to eq([job])
      end
    end

    context '.when employer is signed_in' do
      before{ 
        employer_profile
        sign_in(employer) 
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
        employer_profile
        sign_in(employer) 
      }

      it 'redirects to candidates login page' do
        post :candidate_save_job, job_id: job.id
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end
end
