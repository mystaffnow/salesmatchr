require 'rails_helper'

RSpec.describe JobCandidatesController, :type => :controller do
  before(:each) do
    @candidate = create(:candidate, archetype_score: 200)
    @job_function = create(:job_function)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
    @job = create(:job, employer_id: @employer.id, salary_low: 50000, salary_high: 150000, state_id: @state.id, job_function_id: @job_function.id)
  end

  let(:valid_attributes) {
    {
      "status": "submitted",
      "job_id": @job.id,
      "candidate_id": @candidate.id#,
      # "is_hired": "nil"
    }
  }

  let(:invalid_attributes) {
    {
      "params" => {
        id: 1
      }
    }
  }

  describe '#index' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should correctly assign @job_candidates' do
        @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
        get :index
        expect(assigns(:job_candidates)).to eq([@job_candidate])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should through error without current_candidate' do
        expect{ get :index }.to raise_error("undefined method `id' for nil:NilClass")
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#apply' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @job' do
        get :apply, id: @candidate.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should create one job_candidate record' do
        get :apply, id: @candidate.id
        expect(JobCandidate.count).to eq(1)
      end

      it 'should redirect_to job_receipt_path' do
        @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
        get :apply, id: @candidate.id
        expect(response).to redirect_to(job_receipt_path(JobCandidate.last))
      end

      it 'sends job_application email to an employer' do
        expect { get :apply, id: @candidate.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should have job_candidate status submitted' do
        get :apply, id: @candidate.id
        expect(JobCandidate.last.status).to eq('submitted')
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :apply, id: @candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should through error without current_candidate' do
        expect{get :apply, id: @candidate.id}.to raise_error("undefined method `id' for nil:NilClass")
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :apply, id: @candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#receipt' do
    before(:each) do
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @job' do
        get :receipt, id: @job_candidate.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job_candidate and assign @job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        get :receipt, id: @job_candidate.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :receipt, id: @job_candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @job' do
        get :receipt, id: @job_candidate.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job_candidate and assign @job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        get :receipt, id: @job_candidate.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :receipt, id: @job_candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#update' do
    before(:each) do
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_job_candidate and assign @job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
      end

      it 'should correctly assign @job_candidate' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        expect(assigns(:job_candidate)).to eq(@job_candidate)
      end

      it 'should update record with valid_attributes' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        @job_candidate.reload
        expect(@job_candidate.job_id).to eq(@job.id)
        expect(@job_candidate.candidate_id).to eq(@candidate.id)
      end

      it 'should send send_job_withdrawn email to employer' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        expect { get :update, {id: @job_candidate.id, job_candidate: valid_attributes} }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect_to job_candidates_path' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        expect(response).to redirect_to(job_candidates_path)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :apply, id: @candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_job_candidate and assign @job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
      end

      it 'should correctly assign @job_candidate' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        expect(assigns(:job_candidate)).to eq(@job_candidate)
      end

      it 'should update record with valid_attributes' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        @job_candidate.reload
        expect(@job_candidate.job_id).to eq(@job.id)
        expect(@job_candidate.candidate_id).to eq(@candidate.id)
      end

      it 'should send send_job_hire email to candidate' do
        expect { get :update, {id: @job_candidate.id, job_candidate: valid_attributes} }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect_to employer_jobs_path' do
        get :update, {id: @job_candidate.id, job_candidate: valid_attributes}
        expect(response).to redirect_to(employer_jobs_path)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :receipt, id: @job_candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#remove_candidate' do
    before(:each) do
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should raise error when current_employer not found' do
        expect{post :remove_candidate, { job_id: @job.id, candidate_id: @candidate.id }}.to raise_error("undefined method `email' for nil:NilClass")
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        post :remove_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should update job_candidate status deleted' do
        post :remove_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        @job_candidate.reload
        expect(@job_candidate.status).to eq("deleted")
      end

      it 'should recirect_to employer_show_path' do
        post :remove_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        expect(response).to redirect_to(employer_show_path(@job.id))
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :receipt, id: @job_candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#shortlist_candidate' do
    before(:each) do
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should raise error when current_employer not found' do
        expect{post :shortlist_candidate, { job_id: @job.id, candidate_id: @candidate.id }}.to raise_error("undefined method `email' for nil:NilClass")
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        post :shortlist_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}
      
      it 'should update job_candidate status to shortlisted' do
        post :shortlist_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        @job_candidate.reload
        expect(@job_candidate.status).to eq("shortlist")
      end

      it 'should recirect_to employer_show_path' do
        post :shortlist_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        expect(response).to redirect_to(employer_show_path(@job.id))
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        post :shortlist_candidate, { job_id: @job.id, candidate_id: @candidate.id }
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
