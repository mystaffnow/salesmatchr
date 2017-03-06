require 'rails_helper'

RSpec.describe JobCandidatesController, :type => :controller do
  let(:path) {File.open("#{Rails.root}/public/img/incognito.png", "rb+")}
  let(:state) {create(:state)}
  let(:education_level) {create(:education_level)}
  let(:candidate) {create(:candidate, archetype_score: 35)}
  let(:job_function) {create(:job_function)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:job) {create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id)}

  describe '#index' do
    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it '#require_candidate_profile' do
        CandidateProfile.first.destroy
        get :index
        expect(response).to redirect_to(candidates_account_path)
      end

      it 'should correctly assign job_candidates' do
        job_candidate = create(:job_candidate, job_id: job.id, candidate_id: candidate.id)
        get :index
        expect(assigns(:job_candidates)).to eq([job_candidate])
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{
        sign_in(employer)
        employer_profile(employer)
         }

      it 'should redirect to candidate signin page' do
        get :index
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#apply' do
    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it '#require_candidate_profile' do
        CandidateProfile.first.destroy
        get :apply, id: job.id
        expect(response).to redirect_to(candidates_account_path)
      end

      it 'should correctly assign job' do
        get :apply, id: job.id
        expect(assigns(:job)).to eq(Job.last)
      end

      it 'should create one job_candidate record' do
        get :apply, id: job.id
        expect(JobCandidate.count).to eq(1)
      end

      it 'should redirect_to job_receipt_path' do
        job_candidate = create(:job_candidate, job_id: job.id, candidate_id: candidate.id)
        get :apply, id: job.id
        expect(response).to redirect_to(job_receipt_path(JobCandidate.last))
      end

      it 'sends job_application email to an employer' do
        job
        expect { get :apply, id: job.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should have job_candidate status submitted' do
        get :apply, id: job.id
        expect(JobCandidate.last.status).to eq('submitted')
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :apply, id: job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should redirect to candidate login page' do
        get :apply, id: job.id
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#receipt' do
    let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id)}

    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it 'should correctly assign job' do
        get :receipt, id: job_candidate.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job_candidate and assign job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        get :receipt, id: job_candidate.id
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :receipt, id: job_candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should redirect to candidate login page' do
        get :receipt, id: job_candidate
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#withdraw' do
    let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id)}

    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it 'should call set_job_candidate and assign job_candidate' do
        expect(controller).to receive(:set_job_candidate).once.and_call_original
        put :withdraw, id: job_candidate.id
      end

      it 'should correctly assign job_candidate' do
        put :withdraw, id: job_candidate.id
        expect(assigns(:job_candidate)).to eq(job_candidate)
      end

      it 'should update job_candidate status to withdrawn' do
        put :withdraw, id: job_candidate.id
        job_candidate.reload
        expect(job_candidate.status).to eq("withdrawn")
      end

      it 'should send send_job_withdrawn email to employer' do
        expect { put :withdraw, id: job_candidate.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect_to job_candidates_path' do
        put :withdraw, id: job_candidate.id
        expect(response).to redirect_to(job_candidates_path)
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        put :withdraw, id: job_candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should redirect to employer login page' do
        put :withdraw, id: job_candidate.id
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#accept_candidate' do
    let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id)}

    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it 'should redirect to employer login page' do
        put :accept_candidate, id: job_candidate.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should update job_candidate status accepted' do
        put :accept_candidate, id: job_candidate.id
        job_candidate.reload
        expect(job_candidate.status).to eq("accepted")
      end

      it 'should redirect_to employer_show_path' do
        put :accept_candidate, id: job_candidate.id
        expect(response).to redirect_to(employer_jobs_path)
      end

      it 'should send send_job_hire email to candidate' do
        expect { put :accept_candidate, id: job_candidate.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        put :accept_candidate, id: job_candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#remove_candidate' do
    let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id)}

    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it 'should redirect to employer login page' do
        post :remove_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
      }

      it 'should update job_candidate status deleted' do
        job_candidate
        post :remove_candidate, { job_id: job.id, candidate_id: candidate.id }
        job_candidate.reload
        expect(job_candidate.status).to eq("deleted")
      end

      it 'should redirect_to employer_show_path' do
        job_candidate
        post :remove_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to(employer_show_path(job.id))
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        post :remove_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#shortlist_candidate' do
    let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id)}

    context '.when candidate is sign_in' do
      before{ 
        sign_in(candidate) 
        candidate_profile(candidate)
      }

      it 'should redirect_to employer login page' do
        post :shortlist_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before{ 
        sign_in(employer) 
        employer_profile(employer)
        job_candidate
      }
      
      it 'should update job_candidate status to shortlisted' do
        post :shortlist_candidate, { job_id: job.id, candidate_id: candidate.id }
        job_candidate.reload
        expect(job_candidate.status).to eq("shortlist")
      end

      it 'should redirect_to employer_show_path' do
        post :shortlist_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to(employer_show_path(job.id))
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        post :shortlist_candidate, { job_id: job.id, candidate_id: candidate.id }
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
