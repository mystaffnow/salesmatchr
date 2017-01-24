require 'rails_helper'

RSpec.describe CandidateJobActionsController, :type => :controller do
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
      "candidate_id" => @candidate.id,
      "job_id" => @job.id,
      "is_saved" => false
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
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      it "should correctly assign @candidate_job_actions" do
        get :index
        expect(assigns(:candidate_job_actions)).to eq([@candidate_job_action])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      it "should assign @candidate_job_actions" do
        get :index
        expect(assigns(:candidate_job_actions)).to eq([@candidate_job_action])
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end


  describe "#show" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      it "should correctly assign @candidate_job_action" do
        get :show, id: @candidate_job_action.id
        expect(assigns(:candidate_job_action)).to eq(@candidate_job_action)
      end

      it "should call set_candidate_job_action method" do
        expect(controller).to receive(:set_candidate_job_action).once.and_call_original

        get :show, id: @candidate_job_action.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      it "should correctly assign @candidate_job_action" do
        get :show, id: @candidate_job_action.id
        expect(assigns(:candidate_job_action)).to eq(@candidate_job_action)
      end

      it "should call set_candidate_job_action method" do
        expect(controller).to receive(:set_candidate_job_action).once.and_call_original

        get :show, id: @candidate_job_action.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to("/employers/account")
      end

    end
  end


  describe "#new" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      it "should correctly assign @candidate_job_action" do
        get :new
        expect(assigns(:candidate_job_action)).to be_a_new(CandidateJobAction)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :new
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      it "should correctly assign @candidate_job_action" do
        get :new
        expect(assigns(:candidate_job_action)).to be_a_new(CandidateJobAction)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :new
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#edit" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      it "should correctly assign @candidate_job_action" do
        get :edit, id: @candidate_job_action.id
        expect(assigns(:candidate_job_action)).to eq(@candidate_job_action)
      end

      it "should call set_candidate_job_action method" do
        expect(controller).to receive(:set_candidate_job_action).once.and_call_original

        get :edit, id: @candidate_job_action.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :edit, id: @candidate_job_action.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      it "should correctly assign @candidate_job_action" do
        get :edit, id: @candidate_job_action.id
        expect(assigns(:candidate_job_action)).to eq(@candidate_job_action)
      end

      it "should call set_candidate_job_action method" do
        expect(controller).to receive(:set_candidate_job_action).once.and_call_original
        get :edit, id: @candidate_job_action.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :edit, id: @candidate_job_action.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#candidate_job_saved" do
    context '.when candidate is signed_in' do
      before{ sign_in(@candidate) }

      it 'should assign @candidate_job_action' do
        @candidate_job_action.update(is_saved: true)
        @candidate_job_action.reload
        get :candidate_job_saved
        expect(assigns(:candidate_job_action)).to eq([@candidate_job_action])
      end
    end

    context '.when employer is signed_in' do
      before{ sign_in(@employer) }

      it 'should throw error when current_candidate not found' do
        expect{get :candidate_job_saved }.to raise_error("undefined method `id' for nil:NilClass")
      end
    end
  end

  describe "#candidate_job_viewed" do
    context '.when candidate is signed_in' do
      before{ sign_in(@candidate) }

      it 'should assign @candidate_job_action' do
        get :candidate_job_viewed
        expect(assigns(:candidate_job_action)).to eq([@candidate_job_action])
      end
    end

    context '.when employer is signed_in' do
      before{ sign_in(@employer) }

      it 'should throw error when current_candidate not found' do
        expect{get :candidate_job_viewed }.to raise_error("undefined method `id' for nil:NilClass")
      end
    end
  end

  describe "#candidate_matches" do
    context '.when candidate is signed_in' do
      before{ sign_in(@candidate) }

      it 'should assign @jobs' do
        @job.update_attributes(archetype_low: 10, archetype_high: 201, is_active: true)
        @job.reload
        get :candidate_matches
        expect(assigns(:jobs)).to eq([@job])
      end
    end

    context '.when employer is signed_in' do
      before{ sign_in(@employer) }

      it 'should throw error when current_candidate not found' do
        expect{get :candidate_matches }.to raise_error("undefined method `archetype_score' for nil:NilClass")
      end
    end
  end

  describe "#save" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      context "with valid params" do
        it "creates a new CandidateJobAction" do
          post :create, {candidate_job_action: valid_attributes}
          expect(CandidateJobAction.count).to eq(1)
        end

        it "should correctly assign @candidate_job_action" do
          post :create, {candidate_job_action: valid_attributes}
          expect(assigns(:candidate_job_action)).to be_a(CandidateJobAction)
          expect(assigns(:candidate_job_action)).to be_persisted
        end

        it "redirects to the created candidate_job_action" do
          post :create, {candidate_job_action: valid_attributes}
          expect(response).to redirect_to("/jobs")
        end
      end

      context "with invalid params" do
        pending("Pending Validation") do
          it "should correctly assign @candidate_job_action" do
            post :create, {candidate_job_action: invalid_attributes}
            expect(assigns(:candidate_job_action)).to be_a_new(CandidateJobAction)
          end

          it "re-renders the 'new' template" do
            post :create, {candidate_job_action: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end  

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        post :create, {candidate_job_action: valid_attributes}
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      context "with valid params" do
        it "creates a new CandidateJobAction" do
          post :create, {candidate_job_action: valid_attributes}
          expect(CandidateJobAction.count).to eq(1)
        end

        it "should correctly assign @candidate_job_action" do
          post :create, {candidate_job_action: valid_attributes}
          expect(assigns(:candidate_job_action)).to be_a(CandidateJobAction)
          expect(assigns(:candidate_job_action)).to be_persisted
        end

        it "redirects to the created candidate_job_action" do
          post :create, {candidate_job_action: valid_attributes}
          expect(response).to redirect_to("/jobs")
        end
      end

      context "with invalid params" do
        pending("Pending Validation") do
          it "should correctly assign @candidate_job_action" do
            post :create, {candidate_job_action: invalid_attributes}
            expect(assigns(:candidate_job_action)).to be_a_new(CandidateJobAction)
          end

          it "re-renders the 'new' template" do
            post :create, {candidate_job_action: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        post :create, {candidate_job_action: valid_attributes}
        expect(response).to redirect_to("/employers/account")
      end      
    end
  end


  describe "#update" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      context "with valid params" do
  
        let(:new_attributes) {
          {
            "candidate_id" => @candidate.id,
            "job_id" => @job.id,
            "is_saved" => false
          }
        }

        it "updates the requested candidate_job_action" do
          candidate_job_action = create(:candidate_job_action, valid_attributes)
          put :update, {id: candidate_job_action.to_param, candidate_job_action: new_attributes}
          candidate_job_action.reload
          expect(candidate_job_action.is_saved).to eq(false)
          expect(candidate_job_action.candidate_id).to eq(@candidate.id)
          expect(candidate_job_action.job_id).to eq(@job.id)
        end

        it "should correctly assign @candidate_job_action" do
          candidate_job_action = create(:candidate_job_action, valid_attributes)
          put :update, {id: candidate_job_action.to_param, candidate_job_action: valid_attributes}
          expect(assigns(:candidate_job_action)).to eq(candidate_job_action)
        end

        it "redirects to the candidate_job_action" do
          candidate_job_action = create(:candidate_job_action, valid_attributes)
          put :update, {id: candidate_job_action.to_param, candidate_job_action: valid_attributes}
          expect(response).to redirect_to(candidate_job_action)
        end
      end

      context "with invalid params" do
        pending("Pending Validation") do
          it "should correctly assign @candidate_job_action" do
            candidate_job_action = create(:candidate_job_action, valid_attributes)
            put :update, {id: candidate_job_action.to_param, candidate_job_action: invalid_attributes}
            expect(assigns(:candidate_job_action)).to eq(candidate_job_action)
          end

          it "re-renders the 'edit' template" do
            candidate_job_action = create(:candidate_job_action, valid_attributes)
            put :update, {id: candidate_job_action.to_param, candidate_job_action: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      context "with valid params" do
        let(:new_attributes) {
          {
            "candidate_id" => @candidate.id,
            "job_id" => @job.id,
            "is_saved" => false
            }
          }

          it "updates the requested candidate_job_action" do
            candidate_job_action = create(:candidate_job_action, valid_attributes)
            put :update, {id: candidate_job_action.to_param, candidate_job_action: new_attributes}
            candidate_job_action.reload
          end

          it "should correctly assign @candidate_job_action" do
            candidate_job_action = create(:candidate_job_action, valid_attributes)
            put :update, {id: candidate_job_action.to_param, candidate_job_action: valid_attributes}
            expect(assigns(:candidate_job_action)).to eq(candidate_job_action)
          end

          it "redirects to the candidate_job_action" do
            candidate_job_action = create(:candidate_job_action, valid_attributes)
            put :update, {id: candidate_job_action.to_param, candidate_job_action: valid_attributes}
            expect(response).to redirect_to(candidate_job_action)
          end
        end

        context "with invalid params" do
          pending("Pending Validation") do
            it "should correctly assign @candidate_job_action" do
              candidate_job_action = create(:candidate_job_action, valid_attributes)
              put :update, {id: candidate_job_action.to_param, candidate_job_action: invalid_attributes}
              expect(assigns(:candidate_job_action)).to eq(candidate_job_action)
            end

            it "re-renders the 'edit' template" do
              candidate_job_action = create(:candidate_job_action, valid_attributes)
              put :update, {id: candidate_job_action.to_param, candidate_job_action: invalid_attributes}
              expect(response).to render_template("edit")
            end
          end
        end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end


  describe "#destroy" do
    context '.when candidate is signed in' do
      before { sign_in(@candidate)}

      it "destroys the requested candidate_job_action" do
        candidate_job_action = create(:candidate_job_action, valid_attributes)
        expect {
          delete :destroy, {id: candidate_job_action.to_param}
        }.to change(CandidateJobAction, :count).by(-1)
      end

      it "redirects to the candidate_job_actions list" do
        candidate_job_action = create(:candidate_job_action, valid_attributes)
        delete :destroy, {id: candidate_job_action.to_param}
        expect(response).to redirect_to(candidate_job_actions_url)
      end
      
      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before { sign_in(@employer)}

      it "destroys the requested candidate_job_action" do
        candidate_job_action = create(:candidate_job_action, valid_attributes)
        expect {
          delete :destroy, {id: candidate_job_action.to_param}
        }.to change(CandidateJobAction, :count).by(-1)
      end

      it "redirects to the candidate_job_actions list" do
        candidate_job_action = create(:candidate_job_action, valid_attributes)
        delete :destroy, {id: candidate_job_action.to_param}
        expect(response).to redirect_to(candidate_job_actions_url)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @candidate_job_action.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
