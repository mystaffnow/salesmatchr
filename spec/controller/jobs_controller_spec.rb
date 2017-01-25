require 'rails_helper'

RSpec.describe JobsController, :type => :controller do
  before(:each) do
    @candidate = create(:candidate, archetype_score: 200)
    @job_function = create(:job_function)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
    @job = create(:job, employer_id: @employer.id, salary_low: 50000, salary_high: 150000, state_id: @state.id, job_function_id: @job_function.id)
    @candidate_job_action = create(:candidate_job_action, candidate_id: @candidate.id, job_id: @job.id)    
  end

  let(:valid_attributes) {
    {
      # "distance": nil, 
      "job_function_id": @job_function.id,
      "employer_id": @employer.id,
      "city": 'Boston',
      "state_id": @state.id,
      "archetype_low": 20,
      "archetype_high": 70,
      "salary_low": 55000,
      "salary_high": 550000,
      "zip": 1050,
      "is_remote": true,
      "title": 'Sales Manager',
      "description": 'This is general description',
      "is_active": false,
      "experience_years": 5,
      "stripe_token": nil
    }
  }

  let(:invalid_attributes) {
    {
      id: 1,
      job_function_id: @job_function.id
    }
  }

  describe '#index' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}
      it 'should redirect_to candidate_matches_path' do
        get :index
        expect(response).to redirect_to(candidate_matches_path)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}
      it 'unauthorized access' do
        expect{get :index}.to raise_error("Unauthorized access")
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#show' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}
      
      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :show, id: @job.id
      end

      it 'should properly assign @candidate_job_action' do
        get :show, id: @job.id
        expect(assigns(:candidate_job_action)).to eq(@candidate_job_action)
      end

      it 'should properly assign @job' do
        get :show, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should create new candidate_job_action with is_saved status false when @candidate_job_action is nil' do
        @employer = create(:employer)
        @job = create(:job, employer_id: @employer.id, city: 'my city', state_id: @state.id, zip: 1200)
        get :show, id: @job.id
        expect(assigns(CandidateJobAction.last.is_saved)).to be_falsy
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :show, id: @job.id
      end

      it 'should properly assign @job' do
        get :show, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#new' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'Unauthorized access' do
        expect{get :new}.to raise_error("Unauthorized Access")
      end

      it 'should raise error when current_employer not found' do
        expect{ get :new }.to raise_error("undefined method `jobs' for nil:NilClass")
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      let(:required_params) {
        { copy_id: @job.id }
      }

      it 'should properly assign @job' do
        get :new
        expect(assigns(:job)).to be_a_new(Job)
      end

      it 'should find job and assign to @job and @job.id should be nil' do
        get :new, { copy_id: @job.id }
        @job.reload
        expect(assigns(:job)[:id]).to eq(nil)
      end

      it 'employer should pay to post more than two jobs' do
        @job1 = create(:job, employer_id: @employer.id, city: 'my city', state_id: @state.id, zip: 1200)
        @job2 = create(:job, employer_id: @employer.id, city: 'my city', state_id: @state.id, zip: 1200)
        @job3 = create(:job, employer_id: @employer.id, city: 'my city', state_id: @state.id, zip: 1200)
        get :new
        expect(assigns(:should_pay)).to be_truthy
      end

      it 'First two jobs are free and employer should not pay' do
        get :new
        expect(assigns(:should_pay)).to be_falsy
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#send_intro' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @job' do
        get :send_intro, { candidate_id: @candidate.id, id: @job.id }
        expect(assigns(:job)).to eq(@job)
      end

      it 'should correctly assign @candidate' do
        get :send_intro, { candidate_id: @candidate.id, id: @job.id }
        expect(assigns(:candidate)).to eq(@candidate)
      end

      it 'should send_job_intro email to candidate' do
        expect { get :send_intro, { candidate_id: @candidate.id, id: @job.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :send_intro, { candidate_id: @candidate.id, id: @job.id }
        expect(assigns(:job)).to eq(@job)
      end

      it 'should correctly assign @candidate' do
        get :send_intro, { candidate_id: @candidate.id, id: @job.id }
        expect(assigns(:candidate)).to eq(@candidate)
      end

      it 'should send_job_intro email to candidate' do
        expect { get :send_intro, { candidate_id: @candidate.id, id: @job.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#edit' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it '#unauthorized access' do
        expect{get :edit, id: @job.id}.to raise_error("Unauthorized access")
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :edit, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized acess' do
          @fake_employer = create(:employer)
          sign_in(@fake_employer)
          expect{get :edit, id: @job.id}.to raise("Unauthorized access")
        end
      end

      context 'job belongs to signed in employer' do
        before{ sign_in(@employer) }

        it 'should correctly assign @job' do
          get :edit, id: @job.id
          expect(assigns(:job)).to eq(@job)
        end

        it 'should call set_job method' do
          expect(controller).to receive(:set_job).once.and_call_original
          get :edit, id: @job.id
        end

        it 'should redirect to /employers/account' do
          @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
          get :edit, id: @job.id
          expect(response).to redirect_to("/employers/account")
        end
      end
    end
  end

  describe '#employer_show' do
    context '.when candidate is sign_in' do
      before(:each) do
        @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id, status: 'submitted')
      end
      before{ sign_in(@candidate) }

      it 'should correctly assign @job' do
        get :employer_show, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show, id: @job.id
      end

      it 'should delete all job_candidate whose status is shortlist' do
        @job_candidate.update(status: "shortlist")
        get :employer_show, id: @job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should delete all job_candidate whose status is deleted' do
        @job_candidate.update(status: "deleted")
        get :employer_show, id: @job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :employer_show, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before(:each) do
        @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id, status: 'submitted')
      end

      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :employer_show, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show, id: @job.id
      end

      it 'should delete all job_candidate whose status is shortlist' do
        @job_candidate.update(status: "shortlist")
        get :employer_show, id: @job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should delete all job_candidate whose status is deleted' do
        @job_candidate.update(status: "deleted")
        get :employer_show, id: @job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_show_actions' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should correctly assign @job' do
        get :employer_show_actions, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_actions, id: @job.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :employer_show_actions, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :employer_show_actions, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_actions, id: @job.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_actions, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_show_matches' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should correctly assign @job' do
        get :employer_show_matches, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_matches, id: @job.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :employer_show_matches, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :employer_show_matches, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_matches, id: @job.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_matches, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_show_shortlists' do
    before(:each) do
      @job_candidate = create(:job_candidate, job_id: @job.id, candidate_id: @candidate.id, status: 'shortlist')
    end

    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should correctly assign @job' do
        get :employer_show_shortlists, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_shortlists, id: @job.id
      end

      it 'should properly assign @shortlists' do
        get :employer_show_shortlists, id: @job.id
        expect(assigns(:shortlists)).to eq([@job_candidate])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :employer_show_shortlists, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :employer_show_shortlists, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_shortlists, id: @job.id
      end

      it 'should properly assign @shortlists' do
        get :employer_show_shortlists, id: @job.id
        expect(assigns(:shortlists)).to eq([@job_candidate])
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_shortlists, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_index' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should raise error when current_employer not found' do
        expect{get :employer_index}.to raise_error("undefined method `id' for nil:NilClass")
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should properly assigns @jobs' do
        @job.update(is_active: true)
        @job.reload
        get :employer_index
        expect(assigns(:jobs)).to eq([@job])
      end

      it 'should count inactive jobs and assigns to @inactive_job_count' do
        get :employer_index
        expect(Job.count).to eq(1)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_index, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#employer_archive" do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should raise error when current_employer not found' do
        expect{get :employer_archive}.to raise_error("undefined method `id' for nil:NilClass")
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should properly assigns @jobs' do
        get :employer_archive
        expect(assigns(:jobs)).to eq([@job])
      end

      it 'should count open jobs and assigns to @active_job_count' do
        @job.update(is_active: true)
        @job.reload
        get :employer_archive
        expect(Job.count).to eq(1)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_archive, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#inactivate_job' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should correctly assign @job' do
        get :inactivate_job, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :inactivate_job, id: @job.id
      end

      it 'should toggle job is_active to true' do
        @job.update(is_active: false)
        get :inactivate_job, id: @job.id
        expect(assigns[:job][:is_active]).to be_truthy
      end

      it 'should toggle job is_active to false' do
        @job.update(is_active: true)
        get :inactivate_job, id: @job.id
        expect(assigns[:job][:is_active]).to be_falsy
      end

      it 'should redirect to employer_jobs_path' do
        get :inactivate_job, id: @job.id
        expect(response).to redirect_to(employer_jobs_path)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :inactivate_job, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      it 'should correctly assign @job' do
        get :inactivate_job, id: @job.id
        expect(assigns(:job)).to eq(@job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :inactivate_job, id: @job.id
      end

      it 'should toggle job is_active to true' do
        @job.update(is_active: false)
        get :inactivate_job, id: @job.id
        expect(assigns[:job][:is_active]).to be_truthy
      end

      it 'should toggle job is_active to false' do
        @job.update(is_active: true)
        get :inactivate_job, id: @job.id
        expect(assigns[:job][:is_active]).to be_falsy
      end

      it 'should redirect to employer_jobs_path' do
        get :inactivate_job, id: @job.id
        expect(response).to redirect_to(employer_jobs_path)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :inactivate_job, id: @job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#create' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it 'should through error when current_employer not found' do
        expect{post :create, job: valid_attributes}.to raise_error("undefined method `id' for nil:NilClass")
      end
    end

    context '.when employer is sign_in' do
      before{ sign_in(@employer) }

      context '.with valid attributes' do
        it 'should create a new Job' do
          Job.destroy_all
          post :create, {job: valid_attributes}
          expect(Job.count).to eq(1)
        end

        it 'should correctly assign @job' do
          post :create, {job: valid_attributes}
          expect(assigns(:job)).to eq(Job.last)
        end

        it 'should redirect to employer_archive_jobs_path' do
          post :create, {job: valid_attributes}
          expect(response).to redirect_to(employer_archive_jobs_path)
        end

        it 'should implement stripe'

        it 'should redirect to /employers/account' do
          @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
          post :create, {job: valid_attributes}
          expect(response).to redirect_to("/employers/account")
        end
      end

      context '.with invalid_attributes' do
        pending("Pending Validation") do
          it "should correctly assign @job" do
            post :create, {job: invalid_attributes}
            expect(assigns(:job)).to be_a_new(Job)
          end

          it "re-renders the 'new' template" do
            post :create, {job: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end
  end

  # describe '#employer_job_checkout'

  describe '#update' do
    let(:new_attributes) {
      {
        #"distance": nil, # unknown attributes distance for job
        "job_function_id": @job_function.id,
        "employer_id": @employer.id,
        "city": "New York",
        "state_id": @state.id,
        "archetype_low": -10,
        "archetype_high": 101,
        "salary_low": 89000,
        "salary_high": 360000,
        "zip": 58001,
        "is_remote": false,
        "title": 'Opening for Sales assistant',
        "description": 'This is general description',
        "is_active": false,
        "experience_years": 2,
        "stripe_token": nil
      }
    }

    context '.when candidate is sign_in' do
      before{sign_in(@candidate)}

      it '#unauthorized access' do
        expect{put :update, {id: @job.id, job: valid_attributes}}.to raise_error("Unauthorized access")
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        put :update, {id: @job.id, job: new_attributes}
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized acess' do
          @fake_employer = create(:employer)
          sign_in(@fake_employer)
          expect{put :update, {id: @job.id, job: new_attributes}}.to raise("Unauthorized access")
        end
      end

      context 'and job belongs to signed in employer' do
        before{sign_in(@employer)}

        context '.with valid attributes' do
          it 'should correctly assign @job' do
            put :update, {id: @job.id, job: new_attributes}
            expect(assigns(:job)).to eq(@job)
          end

          it 'should call set_job' do
            expect(controller).to receive(:set_job).once.and_call_original
            put :update, {id: @job.id, job: new_attributes}
          end

          it 'should update the job with new_attributes' do
            put :update, {id: @job.id, job: new_attributes}
            @job.reload
            expect(@job.city).to eq( "New York")
            expect(@job.zip).to eq("58001")
          end

          it 'should redirect_to employer_jobs_path' do
            put :update, {id: @job.id, job: new_attributes}
            expect(response).to redirect_to(employer_jobs_path)
          end
        end

        context '.with invalid_attributes' do
          pending("Pending Validation") do
            it 'should correctly assign @job' do
              put :update, {id: @job.id, job: invalid_attributes}
              expect(assigns(:job)).to eq(@job)
            end

            it "re-renders the 'edit' template" do
              job = create(:job, valid_attributes)
              put :update, {id: job.to_param, job: invalid_attributes}
              expect(response).to render_template("edit")
            end
          end
        end
      end
    end
  end

  describe '#destroy' do
    context '.when candidate is sign_in' do
      before{ sign_in(@candidate) }

      it '#unauthorized access' do
        expect{delete :destroy, id: @job.id}.to raise_error("Unauthorized access")
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        delete :destroy, id: @job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    describe '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized acess' do
          @fake_employer = create(:employer)
          sign_in(@fake_employer)
          expect{delete :destroy, id: @job.id}.to raise("Unauthorized access")
        end
      end

      context 'job belongs to signed in employer' do
        before{ sign_in(@employer) }

        it 'should assign @job' do
          delete :destroy, id: @job.id
          expect(assigns(:job)).to eq(@job)
        end

        it 'should call set_job' do
          expect(controller).to receive(:set_job).once.and_call_original
          delete :destroy, id: @job.id
        end

        it 'should delete the record' do
          expect{delete :destroy, id: @job.id}.to change(Job, :count).by(-1)
        end

        it 'should redirect_to jobs_url' do
          delete :destroy, id: @job.id
          expect(response).to redirect_to(jobs_url)
        end

        it 'should redirect to /employers/account' do
          @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
          get :index
          expect(response).to redirect_to("/employers/account")
        end
      end
    end
  end
end