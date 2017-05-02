require 'rails_helper'

RSpec.describe JobsController, :type => :controller do
  let(:candidate) {create(:candidate, archetype_score: 35)}
  let(:job_function) {create(:job_function)}
  let(:state) {create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:job) {create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id, is_active: true)}
  let(:candidate_job_action) {create(:candidate_job_action, candidate_id: candidate.id, job_id: job.id) }

  let(:valid_attributes) {
    {
      "job_function_id": job_function.id,
      "employer_id": employer.id,
      "city": 'Boston',
      "state_id": state.id,
      "salary_low": 55000,
      "salary_high": 550000,
      "zip": 1050,
      "is_remote": true,
      "title": 'Sales Manager',
      "description": 'This is general description',
      "is_active": false,
      "experience_years": 5,
      "stripe_token": nil,
      "payment": {
        "stripe_card_token": generate_stripe_card_token
      }
    }
  }

  let(:invalid_attributes) {
    {
      id: 1,
      job_function_id: job_function.id
    }
  }

  describe '#index' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}
      
      it 'should redirect_to candidate_matches_path' do
        get :index
        expect(response).to redirect_to(candidate_matches_path)
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'unauthorized access' do
        get :index
        expect(response).to redirect_to(candidate_matches_path)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#show' do
    context '.when candidate is sign_in' do
      before {
        sign_in(candidate)
        candidate_job_action
      }
      
      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :show, id: job.id
      end

      it 'should properly assign candidate_job_action' do
        get :show, id: job.id
        expect(assigns(:candidate_job_action)).to eq(candidate_job_action)
      end

      it 'should properly assign job' do
        get :show, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should create new candidate_job_action with is_saved status false when candidate_job_action is nil' do
        employer = create(:employer)
        job = create(:job, employer_id: employer.id, city: 'my city', state_id: state.id, zip: 1200, job_function_id: job_function.id, is_active: true)
        get :show, id: job.id
        expect(assigns(CandidateJobAction.last.is_saved)).to be_falsy
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :show, id: job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :show, id: job.id
      end

      it 'should properly assign job' do
        get :show, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#new' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect to employer login page' do
        get :new
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      let(:required_params) {
        { copy_id: job.id }
      }

      it 'should properly assign job' do
        get :new
        expect(assigns(:job)).to be_a_new(Job)
      end

      it 'should find job and assign to job and job.id should be nil' do
        get :new, { copy_id: job.id }
        job.reload
        expect(assigns(:job)[:id]).to eq(nil)
      end

      # it 'should build payment for each job' do
      #   get :new
      #   job = assigns(:job)
      #   expect(job.payment).to be_a_new(Payment)
      # end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :new
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  # ToDo: remove this later
  # describe '#send_intro' do
  #   context '.when candidate is sign_in' do
  #     before {sign_in(candidate)}

  #     it 'should correctly assign job' do
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(assigns(:job)).to eq(job)
  #     end

  #     it 'should correctly assign candidate' do
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(assigns(:candidate)).to eq(candidate)
  #     end

  #     it 'should send_job_intro email to candidate' do
  #       expect { get :send_intro, { candidate_id: candidate.id, id: job.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #     end

  #     it 'should redirect to candidates_archetype_path' do
  #       candidate.update(archetype_score: nil)
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(response).to redirect_to(candidates_archetype_path)
  #     end
  #   end

  #   context '.when employer is sign_in' do
  #     before {
  #       sign_in(employer)
  #       employer_profile(employer)
  #     }

  #     it 'should correctly assign job' do
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(assigns(:job)).to eq(job)
  #     end

  #     it 'should correctly assign candidate' do
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(assigns(:candidate)).to eq(candidate)
  #     end

  #     it 'should send_job_intro email to candidate' do
  #       expect { get :send_intro, { candidate_id: candidate.id, id: job.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #     end

  #     it 'should redirect to /employers/account' do
  #       EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
  #       get :send_intro, { candidate_id: candidate.id, id: job.id }
  #       expect(response).to redirect_to("/employers/account")
  #     end
  #   end
  # end

  describe '#edit' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :edit, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :edit, id: job.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized acess' do
          fake_employer = create(:archetype_employer)
          employer_profile(fake_employer)
          sign_in(fake_employer)
          get :edit, id: job.id
          expect(response).to redirect_to('/')
          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end
      end

      context 'job belongs to signed in employer' do
        before {
          sign_in(employer)
          employer_profile(employer)
        }

        it 'should correctly assign job' do
          get :edit, id: job.id
          expect(assigns(:job)).to eq(job)
        end

        it 'should call set_job method' do
          expect(controller).to receive(:set_job).once.and_call_original
          get :edit, id: job.id
        end

        it 'should redirect to /employers/account' do
          EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
          get :edit, id: job.id
          expect(response).to redirect_to("/employers/account")
        end
      end
    end
  end

  describe '#employer_show' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers login path' do
        get :employer_show, id: job.id
        expect(response).to redirect_to('/employers/sign_in')
      end
    end

    context '.when employer is sign_in' do
      let(:job_candidate) {create(:job_candidate, job_id: job.id, candidate_id: candidate.id, status: 'submitted')}

      before {
          sign_in(employer)
          employer_profile(employer)
          job_candidate
        }

      it 'should correctly assign job' do
        get :employer_show, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show, id: job.id
      end

      it 'should not show shortlisted job_candidates' do
        job_candidate.update(status: "shortlist")
        job_candidate.reload
        get :employer_show, id: job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should not show deleted job_candidates' do
        job_candidate.update(status: "deleted")
        job_candidate.reload
        get :employer_show, id: job.id
        expect(assigns(:job_candidates)).to eq([])
      end

      it 'should return job_candidates' do
        get :employer_show, id: job.id
        expect(assigns(:job_candidates)).to eq([job_candidate])
      end

      it 'should return first 25 records only' do
        30.times do |i|
          candidate = create(:candidate)
          CandidateProfile.last.update(is_incognito: false)
          create(:job_candidate, job_id: job.id, candidate_id: candidate.id, status: 'submitted')
        end
        get :employer_show, id: job.id
        expect(Candidate.count).to eq(31)
        expect(assigns(:job_candidates)).to eq(JobCandidate.first(25))
      end     

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_show_actions' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect to employers login page' do
        get :employer_show_actions, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should correctly assign job' do
        get :employer_show_actions, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_actions, id: job.id
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_actions, id: job.id
        expect(response).to redirect_to("/employers/account")
      end

      it 'should return candidates list whose profile are visible and who have viewed the job' do
        candidate
        CandidateProfile.first.update(is_incognito: false)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate.id, is_saved: false)
        
        candidate1 = create(:candidate)
        CandidateProfile.second.update(is_incognito: false)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate1.id, is_saved: false)

        candidate2 = create(:candidate)
        CandidateProfile.third.update(is_incognito: true)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate2.id, is_saved: false)

        get :employer_show_actions, id: job.id
        expect(assigns(:candidates)).to eq([candidate, candidate1])
      end

      it 'should return first 25 records only' do
        30.times do |i|
          candidate = create(:candidate)
          CandidateProfile.last.update(is_incognito: false)
          create(:candidate_job_action, job_id: job.id, candidate_id: candidate.id, is_saved: false)
        end
        get :employer_show_actions, id: job.id
        expect(Candidate.count).to eq(30)
        expect(assigns(:candidates).count).to eq(25)
      end
    end
  end

  describe '#employer_show_matches' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers login page' do
        get :employer_show_matches, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should correctly assign job' do
        get :employer_show_matches, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_matches, id: job.id
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_matches, id: job.id
        expect(response).to redirect_to("/employers/account")
      end

      it 'should return all candidates whose profile matched with job' do
        candidate
        CandidateProfile.first.update(is_incognito: false)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate.id, is_saved: false)
        
        candidate1 = create(:candidate, archetype_score: 35)
        CandidateProfile.second.update(is_incognito: false)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate1.id, is_saved: false)

        candidate2 = create(:candidate, archetype_score: 35)
        CandidateProfile.third.update(is_incognito: true)
        create(:candidate_job_action, job_id: job.id, candidate_id: candidate2.id, is_saved: false)

        get :employer_show_matches, id: job.id
        expect(assigns(:candidates)).to eq([candidate, candidate1])
      end

      it 'should return first 25 records only' do
        30.times do |i|
          candidate = create(:candidate, archetype_score: 35)
          CandidateProfile.last.update(is_incognito: false)
          create(:candidate_job_action, job_id: job.id, candidate_id: candidate.id, is_saved: false)
        end
        get :employer_show_matches, id: job.id
        expect(Candidate.count).to eq(30)
        expect(assigns(:candidates)).to eq(Candidate.first(25))
      end
    end
  end

  describe '#employer_show_shortlists' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :employer_show_shortlists, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should correctly assign job' do
        get :employer_show_shortlists, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_shortlists, id: job.id
      end

      it 'should list all job_candidates whose profile is shortlisted' do
        job_candidate = create(:job_candidate, job_id: job.id, candidate_id: candidate.id, status: 'shortlist')
        candidate1 = create(:candidate)
        job_candidate1 = create(:job_candidate, job_id: job.id, candidate_id: candidate1.id, status: 'shortlist')
        candidate2 = create(:candidate)
        job_candidate2 = create(:job_candidate, job_id: job.id, candidate_id: candidate2.id, status: 'viewed')
        get :employer_show_shortlists, id: job.id
        expect(assigns(:shortlists)).to eq([job_candidate, job_candidate1])
      end

      it 'should return first 25 records only' do
        30.times do |i|
          candidate1 = create(:candidate)
          job_candidate1 = create(:job_candidate, job_id: job.id, candidate_id: candidate1.id, status: 'shortlist')
        end
        get :employer_show_shortlists, id: job.id
        expect(Candidate.count).to eq(30)
        expect(assigns(:shortlists)).to eq(JobCandidate.first(25))
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_shortlists, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_show_remove' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :employer_show_remove, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should correctly assign job' do
        get :employer_show_remove, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :employer_show_remove, id: job.id
      end

      it 'should show all job_candidates whose profile is rejected or deleted' do
        job_candidate = create(:job_candidate, job_id: job.id, candidate_id: candidate.id, status: 'deleted')
        candidate1 = create(:candidate)
        job_candidate1 = create(:job_candidate, job_id: job.id, candidate_id: candidate1.id, status: 'deleted')
        candidate2 = create(:candidate)
        job_candidate2 = create(:job_candidate, job_id: job.id, candidate_id: candidate2.id, status: 'viewed')
        get :employer_show_remove, id: job.id
        expect(assigns(:removed_job_candidates)).to eq([job_candidate, job_candidate1])
      end

      it 'should return first 25 records only' do
        30.times do |i|
          candidate1 = create(:candidate)
          job_candidate1 = create(:job_candidate, job_id: job.id, candidate_id: candidate1.id, status: 'deleted')
        end
        get :employer_show_remove, id: job.id
        expect(JobCandidate.count).to eq(30)
        expect(assigns(:removed_job_candidates)).to eq(JobCandidate.first(25))
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_show_remove, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#employer_index' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :employer_index
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should return active and enable jobs of employer' do
        job.update(is_active: true, status: Job.statuses['enable'])
        job.reload
        state1 = create(:state, name: 'title1')
        job1 = create(:job, employer_id: employer.id, state_id: state1.id, is_active: true, status: Job.statuses['disable'])
        state2 = create(:state, name: 'title2')
        job2 = create(:job, employer_id: employer.id, state_id: state2.id, is_active: false, status: Job.statuses['disable'])
        state3 = create(:state, name: 'title3')
        job3 = create(:job, employer_id: employer.id, state_id: state3.id, is_active: false, status: Job.statuses['enable'])
        get :employer_index
        expect(assigns(:jobs)).to eq([job])
      end

      it 'should return 25 records only' do
        30.times do |i|
          state = create(:state, name: "title#{i}")
          job = create(:job, employer_id: employer.id, state_id: state.id, is_active: true, status: Job.statuses['enable'])
        end
        get :employer_index
        expect(assigns(:jobs).count).to eq(25)
      end

      it 'should count inactive jobs and assigns to inactive_job_count' do
        create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id, is_active: false)
        get :employer_index
        expect(Job.count).to eq(1)
        expect(assigns(:inactive_job_count)).to eq(1)
      end

      it 'should count disable jobs' do
        create(:job, employer_id: employer.id, salary_low: 50000, salary_high: 150000, state_id: state.id, job_function_id: job_function.id, is_active: true, status: Job.statuses['expired'])
        get :employer_index
        expect(assigns(:expired_job_count)).to eq(1)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_index, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#employer_archive" do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :employer_archive
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should return list of inactive jobs' do
        job.update(is_active: false, status: Job.statuses['enable'])
        job.reload
        state1 = create(:state, name: 'title1')
        job1 = create(:job, employer_id: employer.id, state_id: state1.id, is_active: true, status: Job.statuses['disable'])
        state2 = create(:state, name: 'title2')
        job2 = create(:job, employer_id: employer.id, state_id: state2.id, is_active: false, status: Job.statuses['disable'])
        state3 = create(:state, name: 'title3')
        job3 = create(:job, employer_id: employer.id, state_id: state3.id, is_active: false, status: Job.statuses['enable'])
        get :employer_archive
        expect(assigns(:jobs)).to eq([job, job3])
      end

      it 'should return 25 records only' do
        30.times do |i|
          state = create(:state, name: "title#{i}")
          job = create(:job, employer_id: employer.id, state_id: state.id, is_active: false, status: Job.statuses['enable'])
        end
        get :employer_archive
        expect(assigns(:jobs).count).to eq(25)
      end

      it 'should count open jobs and assigns to active_job_count' do
        job.update(is_active: true)
        job.reload
        get :employer_archive
        expect(Job.count).to eq(1)
        expect(assigns(:active_job_count)).to eq(1)
      end

      it 'should count expired jobs' do
        job.update(status: Job.statuses['expired'])
        job.reload
        get :employer_archive
        expect(assigns(:expired_job_count)).to eq(1)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :employer_archive, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#list_expired_jobs' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :list_expired_jobs
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should return list of jobs expired by admin' do
        job.update(status: Job.statuses['expired'])
        state1 = create(:state, name: 'title1')
        job1 = create(:job, employer_id: employer.id, state_id: state1.id, status: Job.statuses['expired'])
        state2 = create(:state, name: 'title2')
        job2 = create(:job, employer_id: employer.id, state_id: state2.id, status: Job.statuses['enable'])
        state3 = create(:state, name: 'title3')
        job3 = create(:job, employer_id: employer.id, state_id: state3.id, status: Job.statuses['expired'])
        get :list_expired_jobs
        expect(assigns(:jobs)).to eq([job, job1, job3])
      end

      it 'should return 25 records only' do
        30.times do |i|
          state = create(:state, name: "title#{i}")
          job = create(:job, employer_id: employer.id, state_id: state.id, is_active: true, status: Job.statuses['expired'])
        end
        get :list_expired_jobs
        expect(assigns(:jobs).count).to eq(25)
      end

      it 'should count active jobs' do
        job.update(is_active: true)
        job.reload
        get :list_expired_jobs
        expect(Job.count).to eq(1)
        expect(assigns(:active_job_count)).to eq(1)
      end

      it 'should count inactive jobs' do
        job.update(is_active: false)
        job.reload
        get :list_expired_jobs
        expect(assigns(:inactive_job_count)).to eq(1)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :list_expired_jobs, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#inactivate_job' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :inactivate_job, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      it 'should correctly assign job' do
        get :inactivate_job, id: job.id
        expect(assigns(:job)).to eq(job)
      end

      it 'should call set_job method' do
        expect(controller).to receive(:set_job).once.and_call_original
        get :inactivate_job, id: job.id
      end

      it 'should toggle job is_active to true' do
        job.update(is_active: false)
        get :inactivate_job, id: job.id
        expect(assigns[:job][:is_active]).to be_truthy
      end

      it 'should toggle job is_active to false' do
        job.update(is_active: true)
        get :inactivate_job, id: job.id
        expect(assigns[:job][:is_active]).to be_falsy
      end

      it 'should redirect to employer_jobs_path' do
        get :inactivate_job, id: job.id
        expect(response).to redirect_to(employer_jobs_path)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        get :inactivate_job, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#create' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }
      it 'should redirect_to employers sign_in page' do
        post :create
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      before {
          sign_in(employer)
          employer_profile(employer)
        }

      context '.with valid attributes' do
        it 'should create a new Job' do
          post :create, {job: valid_attributes}
          expect(Job.count).to eq(1)
        end

        it 'should correctly assign job' do
          post :create, {job: valid_attributes}
          expect(assigns(:job)).to eq(Job.last)
        end

        it 'should redirect to employer_archive_jobs_path' do
          post :create, {job: valid_attributes}
          expect(response).to redirect_to(employer_archive_jobs_path)
        end

        # it 'should store payment' do
        #   post :create, {job: valid_attributes}
        #   expect(Payment.count).to eq(1)
        #   expect(Payment.last.employer_id).to eq(employer.id)
        #   expect(Payment.last.job_id).to eq(Job.last.id)
        #   expect(Payment.last.stripe_card_token).to eq(valid_attributes[:payment][:stripe_card_token])
        #   expect(Payment.last.stripe_customer_id).not_to be_blank
        #   expect(Payment.last.stripe_charge_id).not_to be_blank
        #   expect(Payment.last.status).to eq("charged")
        #   expect(Payment.last.amount).to eq(JOB_POSTING_FEE.to_f)
        # end

        # it 'should send email to matches candidates' do
        #   @candidate = create(:candidate, archetype_score: 30)
        #   @candidate1 = create(:candidate, archetype_score: 31)
        #   @candidate2 = create(:candidate, archetype_score: 50)
        #   @candidate3 = create(:candidate, archetype_score: 80)
        #   @candidate4 = create(:candidate, archetype_score: 100)
        #   @candidate5 = create(:candidate, archetype_score: 101)

        #   expect {post :create, {job: valid_attributes}}.to change { ActionMailer::Base.deliveries.count }.by(5)
        # end

        it 'should redirect to /employers/account' do
          EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
          post :create, {job: valid_attributes}
          expect(response).to redirect_to("/employers/account")
        end

        context '.Account manager' do
          let(:account_manager) { create(:job_function, name: "Account Manager", low: -100, high: -11)}
          let(:attributes) { {job_function_id: account_manager.id, employer_id: employer.id, city: 'Boston',
                state_id: state.id, salary_low: 55000, salary_high: 550000,
                zip: 1050, is_remote: true, title: 'Account manager',
                description: 'This is general description', is_active: false,
                experience_years: 5, payment: {stripe_card_token: generate_stripe_card_token} }}

          it "should store low and high from job_function" do
            post :create, {job: attributes}
            job = Job.first
            expect(Job.count).to eq(1)
            expect(job.archetype_low).to eq(-100)
            expect(job.archetype_high).to eq(-11)
            expect(job.job_function).to eq(account_manager)
            expect(job.title).to eq('Account manager')
            expect(job.employer).to eq(employer)
            expect(job.state).to eq(state)
            expect(job.city).to eq('Boston')
          end
        end
      end

      context '.with invalid_attributes' do
        pending("Pending Validation") do
          it "should correctly assign job" do
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
        "job_function_id": job_function.id,
        "employer_id": employer.id,
        "city": "New York",
        "state_id": state.id,
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
      before{sign_in(candidate)}

      it 'should redirect_to employers sign_in page' do
        put :update, {id: job.id, job: new_attributes}
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized access' do
          fake_employer = create(:archetype_employer)
          employer_profile(fake_employer)
          sign_in(fake_employer)
          put :update, {id: job.id, job: new_attributes}
          expect(response).to redirect_to('/')
          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end
      end

      context 'and job belongs to signed in employer' do
        before {
          sign_in(employer)
          employer_profile(employer)
        }

        context '.with valid attributes' do
          it 'should correctly assign job' do
            put :update, {id: job.id, job: new_attributes}
            expect(assigns(:job)).to eq(job)
          end

          it 'should call set_job' do
            expect(controller).to receive(:set_job).once.and_call_original
            put :update, {id: job.id, job: new_attributes}
          end

          it 'should update the job with new_attributes' do
            put :update, {id: job.id, job: new_attributes}
            job.reload
            expect(job.city).to eq( "New York")
            expect(job.zip).to eq("58001")
          end

          it 'should redirect_to employer_jobs_path' do
            put :update, {id: job.id, job: new_attributes}
            expect(response).to redirect_to(employer_jobs_path)
          end
        end

        context '.with invalid_attributes' do
          pending("Pending Validation") do
            it 'should correctly assign job' do
              put :update, {id: job.id, job: invalid_attributes}
              expect(assigns(:job)).to eq(job)
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
      before{ sign_in(candidate) }

      it 'should redirect_to employers login page' do
        delete :destroy, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    describe '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized access' do
          fake_employer = create(:archetype_employer)
          employer_profile(fake_employer)
          sign_in(fake_employer)
          delete :destroy, id: job.id
          expect(response).to redirect_to('/')
          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end
      end

      context 'job belongs to signed in employer' do
        before {
          sign_in(employer)
          employer_profile(employer)
        }

        it 'should assign job' do
          delete :destroy, id: job.id
          expect(assigns(:job)).to eq(job)
        end

        it 'should call set_job' do
          expect(controller).to receive(:set_job).once.and_call_original
          delete :destroy, id: job.id
        end

        it 'should delete the record' do
          expect{delete :destroy, id: job.id}.to change(Job, :count).by(0)
        end

        it 'should redirect_to jobs_url' do
          delete :destroy, id: job.id
          expect(response).to redirect_to(jobs_url)
        end

        it 'should redirect to /employers/account' do
          EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
          delete :destroy, id: job.id
          expect(response).to redirect_to("/employers/account")
        end
      end
    end
  end

  describe '#email_match_candidates' do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers login page' do
        post :email_match_candidates, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    describe '.when employer is sign_in' do
      context 'and job does not belongs to signed in employer' do
        it 'should raise unauthorized access' do
          fake_employer = create(:archetype_employer)
          employer_profile(fake_employer)
          sign_in(fake_employer)
          post :email_match_candidates, id: job.id
          expect(response).to redirect_to('/')
          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end
      end

      context 'job belongs to signed in employer' do
        before {
          sign_in(employer)
          employer_profile(employer)
        }

        it 'should assign job' do
          post :email_match_candidates, id: job.id
          expect(assigns(:job)).to eq(job)
        end

        it 'should call set_job' do
          expect(controller).to receive(:set_job).once.and_call_original
          post :email_match_candidates, id: job.id
        end

        it 'should redirect when email send to matched candidates' do
          @candidate = create(:candidate, archetype_score: 30)
          @candidate1 = create(:candidate, archetype_score: 31)
          @candidate2 = create(:candidate, archetype_score: 50)
          @candidate3 = create(:candidate, archetype_score: 80)
          @candidate4 = create(:candidate, archetype_score: 100)
          @candidate5 = create(:candidate, archetype_score: 101)

          post :email_match_candidates, id: job.id

          expect(response).to redirect_to(employer_show_matches_path(job.id))
          expect(response).not_to redirect_to(employer_archive_jobs_path(job.id))
        end

        it 'when success' do
          post :email_match_candidates, id: job.id
          expect(response).not_to redirect_to(employer_archive_jobs_path)
        end

        it 'should redirect to /employers/account' do
          EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
          post :email_match_candidates, id: job.id
          expect(response).to redirect_to("/employers/account")
        end
      end
    end
  end

  describe "#pay_to_enable_expired_job" do
    context '.when candidate is sign_in' do
      before{ sign_in(candidate) }

      it 'should redirect_to employers login page' do
        post :pay_to_enable_expired_job, id: job.id
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context 'when employer signed in' do
      before {
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should pay to enable expired job & send matched alert to subscriber' do
        stripe_card_token = generate_stripe_card_token
        
        stripe_customer_id = generate_stripe_customer(stripe_card_token)
        
        customer = create(:customer, stripe_card_token: stripe_card_token,
                                     stripe_customer_id: stripe_customer_id,
                                     employer_id: employer.id,
                                     last4: '4242',
                                     card_number: '4242424242424242')
        
        post :pay_to_enable_expired_job, id: job.id
        
        expect(response).to redirect_to(employer_jobs_path)
        expect(response).not_to redirect_to(employer_job_expired_path)
        expect(Job.count).to eq(1)
        expect(Job.first.enable?).to be_truthy
        expect(Job.first.activated_at > 1.minutes.ago).to be_truthy
        
        expect(Job.first.payments.count).to eq(1)
        expect(Job.first.payments.first.stripe_charge_id).not_to be_nil
        expect(Job.first.payments.first.amount).to eq("#{JOB_POSTING_FEE}".to_i)

        expect(Customer.count).to eq(1)
        expect(Customer.first.employer_id).to eq(employer.id)

        @candidate1 = create(:candidate, archetype_score: 11) # match alert
        CandidateProfile.first.update(is_active_match_subscription: true)

        @candidate2 = create(:candidate, archetype_score: 31) # match, alert
        CandidateProfile.second.update(is_active_match_subscription: true)

        @candidate3 = create(:candidate, archetype_score: 50) # match, no alert
        CandidateProfile.third.update(is_active_match_subscription: false)

        @candidate4 = create(:candidate, archetype_score: 80) # match, no alert
        CandidateProfile.fourth.update(is_active_match_subscription: false)

        @candidate5 = create(:candidate, archetype_score: 100) # match, alert
        CandidateProfile.fifth.update(is_active_match_subscription: true)

        @candidate6 = create(:candidate, archetype_score: 101) # no match, no alert
        CandidateProfile.order("id asc").limit(1).offset(5).first.update(is_active_match_subscription: true)

        @candidate7 = create(:candidate, archetype_score: -10) # no match, no alert
        CandidateProfile.order("id asc").limit(1).offset(6).first.update(is_active_match_subscription: true)
        
        expect {post :pay_to_enable_expired_job, id: job.id}.to change { ActionMailer::Base.deliveries.count }.by(3)
      end

      it 'should redirect to /employers/account when profile info are blank' do
        EmployerProfile.first.update(employer_id: employer.id, zip: nil, state_id: nil, city: nil, website: nil)
        post :email_match_candidates, id: job.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
