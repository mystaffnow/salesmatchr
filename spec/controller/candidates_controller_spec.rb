require 'rails_helper'

RSpec.describe CandidatesController, :type => :controller do
  before(:each) do
    @path = File.open("#{Rails.root}/public/img/incognito.png", "rb+")
    @candidate = create(:candidate, archetype_score: 200, avatar: @path)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Witchia', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
  end

  describe '#archetype' do
    context '.when candidate is sign_in' do
      before { sign_in(@candidate)}

      it 'should_not call check_candidate' do
        @candidate.update(archetype_score: nil)
        get :archetype
        expect(response).not_to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before { sign_in(@employer)}

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :archetype
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#profile' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :profile, id: @candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end

      it 'should correctly assign @candidate, when current_candidate found' do
        get :profile, id: @candidate.id
        expect(assigns(:candidate)).to eq(@candidate)
      end

      it 'should correctly assign @candidate, when params id passed' do
        @candidate1 = create(:candidate)
        get :profile, id: @candidate1.id
        expect(assigns(:candidate)).to eq(@candidate1)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @candidate, when params id passed' do
        @candidate1 = create(:candidate)
        get :profile, id: @candidate1.id
        expect(assigns(:candidate)).to eq(@candidate1)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :profile, id: @candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#account' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :account
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :account
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#update_archetype' do
    before(:each) do
      @year_experience = create(:year_experience)
      @sales_type = create(:sales_type)
      @education_level = create(:education_level)
      @question = create(:question)
      @answer = create(:answer)
      @college = create(:college)
    end
    
    let(:valid_attributes) {
      {
        year_experience_id: @year_experience.id,
        is_incognito: false,
        zip: 1020,
        city: 'Wichita',
        state_id: @state.id,
        education_level_id: @education_level.id,
        archetype_score: 80,
        :experiences_attributes => [
          
          position: 'web developer',
          company: 'Abc inc',
          start_date: 2007-01-01,
          end_date: 2010-01-01,
          description: "This is short description",
          is_sales: nil,
          sales_type_id: @sales_type.id,
          is_current: false
        ],
        :educations_attributes => [
          
          college_id: @college.id,
          college_other: nil,
          education_level_id: @education_level.id,
          description: 'This is short description'
          ],
        :candidate_question_answers_attributes => [
         
          question_id: @question.id,
          answer_id: @answer.id
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

    context '.when candidate is sign_in' do
      before { sign_in(@candidate)}

      context '.with valid params' do
        it 'should update requested info' do
          put :update_archetype, {candidate: valid_attributes}
          @candidate.reload
          expect(@candidate.year_experience_id).to eq(@year_experience.id)
          expect(@candidate.is_incognito).to eq(false)
          expect(@candidate.zip).to eq("1020")
          expect(@candidate.city).to eq('Wichita')
          expect(@candidate.state_id).to eq(@state.id)
          expect(@candidate.education_level_id).to eq(@education_level.id)
          expect(@candidate.archetype_score).to eq(80)
          # to be continued ...
        end

        it 'should redirect to candidates_archetype_result_path' do
          put :update_archetype, {candidate: valid_attributes}
          expect(response).to redirect_to(candidates_archetype_result_path)
        end

        it 'should_not call check_candidate' do
          @candidate.update(archetype_score: nil)
          put :update_archetype, {candidate: valid_attributes}
          expect(response).not_to redirect_to(candidates_archetype_path)
        end
      end

      context '.with invalid params' do
        pending("Pending Validation") do
          it "re-renders the 'edit' template" do
            put :update, {candidate: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end
    end

    context '.when employer is sign_in' do
      before { sign_in(@employer)}

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        put :update_archetype
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end