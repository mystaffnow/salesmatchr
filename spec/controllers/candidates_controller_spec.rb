require 'rails_helper'

RSpec.describe CandidatesController, :type => :controller do
  let(:path) {File.open("#{Rails.root}/public/img/incognito.png", "rb+")}
  let(:candidate) {create(:candidate, archetype_score: 200)}
  let(:state) {create(:state)}
  let(:education_level) {create(:education_level)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:year_experience) {create(:year_experience)}
  let(:sales_type) {create(:sales_type)}
  let(:question) {create(:question)}
  let(:answer) {create(:answer)}
  let(:college) {create(:college)}

  let(:valid_attributes) {
      {
        first_name: 'Test',
        last_name: 'User',
        year_experience_id: year_experience.id,
        archetype_score: candidate.archetype_score,
        :candidate_profile_attributes => {
          is_incognito: false, 
          zip: 1020,
          city: 'Wichita',
          state_id: state.id, 
          ziggeo_token: nil,
          education_level_id: education_level.id 
        },
        :experiences_attributes => [
          position: 'web developer',
          company: 'Abc inc',
          start_date: 2007-01-01,
          end_date: 2010-01-01,
          description: "This is short description",
          is_sales: nil,
          sales_type_id: sales_type.id,
          is_current: false
        ],
        :educations_attributes => [
          college_id: college.id,
          college_other: nil,
          education_level_id: education_level.id,
          description: 'This is short description'
          ],
        :candidate_question_answers_attributes => [
          question_id: question.id,
          answer_id: answer.id
        ]
      }
    }

    let(:invalid_attributes) {
    {
      "params" => {
        id: 1
      }
    }
  }

  describe '#archetype' do
    context '.when candidate is sign_in' do
      before { sign_in(candidate)}

      it 'should_not call check_candidate' do
        candidate.update(archetype_score: nil)
        get :archetype
        expect(response).not_to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :archetype
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#profile' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :profile, id: candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end

      it 'should correctly assign @candidate, when current_candidate found' do
        get :profile, id: candidate.id
        expect(assigns(:candidate)).to eq(candidate)
      end

      it 'should correctly assign @candidate, when params id passed' do
        @candidate1 = create(:candidate)
        get :profile, id: @candidate1.id
        expect(assigns(:candidate)).to eq(@candidate1)
      end
    end

    context '.when employer is sign_in' do
      before {
              employer_profile(employer)
              sign_in(employer)
            }

      it 'should correctly assign @candidate, when params id passed' do
        @candidate1 = create(:candidate)
        get :profile, id: @candidate1.id
        expect(assigns(:candidate)).to eq(@candidate1)
      end

      it 'should redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        get :profile, id: candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#account' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}

      it 'should build candidate profile' do
        get :account
        expect(CandidateProfile.count).to eq(1)
        expect(CandidateProfile.first.candidate_id).to eq(candidate.id)
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :account
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :account
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#update_archetype' do
    context '.when candidate is sign_in' do
      before { sign_in(candidate)}

      context '.with valid params' do
        it 'should update requested info' do
          put :update_archetype, {candidate: valid_attributes}
          candidate.reload
          expect(candidate.first_name).to eq("Test")
          expect(candidate.last_name).to eq("User")
          expect(candidate.year_experience_id).to eq(year_experience.id)
          expect(candidate.candidate_profile.is_incognito).to eq(false)
          expect(candidate.candidate_profile.zip).to eq("1020")
          expect(candidate.candidate_profile.city).to eq('Wichita')
          expect(candidate.candidate_profile.state_id).to eq(state.id)
          expect(candidate.candidate_profile.education_level_id).to eq(education_level.id)
          expect(candidate.archetype_score).to eq(5)
          expect(candidate.experiences.count).to eq(1)
          expect(candidate.experiences.first.position).to eq("web developer")
          expect(candidate.experiences.first.company).to eq("Abc inc")
          expect(candidate.educations.count).to eq(1)
          expect(candidate.educations.first.college_id).to eq(college.id)
          expect(candidate.educations.first.education_level_id).to eq(education_level.id)
          expect(candidate.educations.first.description).to eq("This is short description")
          expect(candidate.candidate_question_answers.count).to eq(1)
          expect(candidate.candidate_question_answers.first.candidate_id).to eq(candidate.id)
          expect(candidate.candidate_question_answers.first.question_id).to eq(question.id)
          expect(candidate.candidate_question_answers.first.answer_id).to eq(answer.id)
        end

        it 'should redirect to candidates_archetype_result_path' do
          put :update_archetype, {candidate: valid_attributes}
          expect(response).to redirect_to(candidates_archetype_result_path)
        end

        it 'should_not call check_candidate' do
          candidate.update(archetype_score: nil)
          put :update_archetype, {candidate: valid_attributes}
          expect(response).not_to redirect_to(candidates_archetype_path)
        end
      end

      context '.with invalid params' do
        pending("Pending Validation") do
          it "re-renders the 'edit' template" do
            put :update_archetype, {candidate: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end
    end

    context '.when employer is sign_in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        put :update_archetype, {candidate: invalid_attributes}
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#archetype_result' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :archetype_result
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :archetype_result
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#update' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}

      context '.with valid_attributes' do
        it 'should update requested info' do
          put :update, {candidate: valid_attributes}
          candidate.reload
          expect(candidate.year_experience_id).to eq(year_experience.id)
          expect(candidate.candidate_profile.is_incognito).to eq(false)
          expect(candidate.candidate_profile.zip).to eq("1020")
          expect(candidate.candidate_profile.city).to eq('Wichita')
          expect(candidate.candidate_profile.state_id).to eq(state.id)
          expect(candidate.candidate_profile.education_level_id).to eq(education_level.id)
          expect(candidate.archetype_score).to eq(200)
          expect(candidate.experiences.count).to eq(1)
          expect(candidate.experiences.first.position).to eq("web developer")
          expect(candidate.experiences.first.company).to eq("Abc inc")
          expect(candidate.educations.count).to eq(1)
          expect(candidate.educations.first.college_id).to eq(college.id)
          expect(candidate.educations.first.education_level_id).to eq(education_level.id)
          expect(candidate.educations.first.description).to eq("This is short description")
          expect(candidate.candidate_question_answers.count).to eq(1)
          expect(candidate.candidate_question_answers.first.candidate_id).to eq(candidate.id)
          expect(candidate.candidate_question_answers.first.question_id).to eq(question.id)
          expect(candidate.candidate_question_answers.first.answer_id).to eq(answer.id)
        end

        it 'should redirect_to candidates_profile_path' do
          put :update, {candidate: valid_attributes}
          expect(response).to redirect_to(candidates_profile_path(candidate))
        end

        it 'should not call check_candidate, need to complete archetype form before continue' do
          candidate.update(archetype_score: nil)
          put :update, {candidate: valid_attributes}
          expect(response).to redirect_to(candidates_archetype_path)
        end
      end


      context '.with invalid params' do
        pending("Pending Validation") do
          it "re-renders the 'account' template" do
            put :update, {candidate: invalid_attributes}
            expect(response).to render_template("account")
          end
        end
      end
    end

    context '.when employer is sign_in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        put :update, {candidate: valid_attributes}
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end
  end

  describe '#incognito' do
    context '.when candidate is sign_in' do
      before {
        candidate_profile(candidate)
        sign_in(candidate)
      }

      it 'should update the requested param info' do
        xhr :get, :incognito, format: :js
        expect(Candidate.count).to eq(1)
        expect(Candidate.last.candidate_profile(candidate).is_incognito).to eq(true)
      end

      it 'should not call check_candidate' do
        candidate.update(archetype_score: nil)
        xhr :get, :incognito, format: :js
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        xhr :get, :incognito, { is_incognito: "true" }
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#subscription" do
    context '.when employer signed in' do
      before { 
        employer_profile(employer)
        sign_in(employer)
      }

      it 'should redirects to candidates sign_in page' do
        get :subscription
        expect(response).to redirect_to("/candidates/sign_in")
      end
    end

    context '.when candidate signed in' do
      before {
        candidate_profile(candidate)
        sign_in(candidate)
      }

      it 'should call check_candidate' do
        candidate.update(archetype_score: nil)
        xhr :get, :subscription, format: :js
        expect(response).to redirect_to(candidates_archetype_path)
      end

      it 'should update subscription' do
        xhr :get, :subscription, format: :js
        expect(assigns(:profile)).to eq(CandidateProfile.first)
        expect(CandidateProfile.count).to eq(1)
        expect(CandidateProfile.first.is_active_match_subscription).to be_falsy
      end
    end
  end
end