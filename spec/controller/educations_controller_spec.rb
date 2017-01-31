require 'rails_helper'

RSpec.describe EducationsController, :type => :controller do
  before(:each) do
    @candidate = create(:candidate, archetype_score: 200)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
    @college = create(:college)
    @education_level = create(:education_level)
  end

  let(:valid_attributes) {
    {
      "school": "school name",
      "degree_id": 1,
      "description": "this is general description",
      "start_date": 7.years.ago.to_date,
      "end_date": 3.years.ago.to_date
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
    before(:each) do
      @education = create(:education, valid_attributes)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @educations' do
        get :index
        expect(assigns(:educations)).to eq([@education])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @educations' do
        get :index
        expect(assigns(:educations)).to eq([@education])
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :index
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#show' do
    before(:each) do
      @education = create(:education, valid_attributes)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        get :show, id: @education.id
      end

      it 'should correctly assign @education' do
        get :show, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @education.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        get :show, id: @education.id
      end

      it 'should correctly assign @education' do
        get :show, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @education.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#new' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @education' do
        get :new
        expect(assigns(:education)).to be_a_new(Education)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :new
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @education' do
        get :new
        expect(assigns(:education)).to be_a_new(Education)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :new
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#edit' do
    before(:each) do
      @education = create(:education, valid_attributes)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        get :edit, id: @education.id
      end

      it 'should correctly assign @education' do
        get :edit, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :edit, id: @education.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        get :edit, id: @education.id
      end

      it 'should correctly assign @education' do
        get :edit, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :edit, id: @education.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#create' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.when valid params' do
        it 'should correctly assign @education' do
          post :create, {education: valid_attributes}
          expect(assigns(:education)).to eq(Education.last)
        end

        it 'should create a new Education' do
          post :create, {education: valid_attributes}
          expect(Education.count).to eq(1)
        end

        it 'should redirect_to created education show page' do
          @education = create(:education, valid_attributes)
          post :create, {education: valid_attributes}
          expect(response).to redirect_to(education_path(Education.last.id))
        end

        it 'should redirect to candidates_archetype_path' do
          @candidate.update(archetype_score: nil)
          post :create, {education: valid_attributes}
          expect(response).to redirect_to(candidates_archetype_path)
        end
      end

      context '.when invalid params' do
        pending('validation is pending') do
          it 'should correctly assign @education' do
            post :create, {education: invalid_attributes}
            expect(assigns(:education)).to be_a_new(Education)
          end

          it 'should render new' do
            post :create, {education: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end

    context '.when employer sign_in' do
      before {sign_in(@employer)}

      context '.when valid params' do
        it 'should correctly assign @education' do
          post :create, {education: valid_attributes}
          expect(assigns(:education)).to eq(Education.last)
        end

        it 'should create a new Education' do
          post :create, {education: valid_attributes}
          expect(Education.count).to eq(1)
        end

        it 'should redirect_to created education show page' do
          @education = create(:education, valid_attributes)
          post :create, {education: valid_attributes}
          expect(response).to redirect_to(education_path(Education.last.id))
        end

        it 'should redirect to /employers/account' do
          @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
          post :create, {education: valid_attributes}
          expect(response).to redirect_to("/employers/account")
        end
      end

      context '.when invalid params' do
        pending('validation is pending') do
          it 'should correctly assign @education' do
            post :create, {education: invalid_attributes}
            expect(assigns(:education)).to be_a_new(Education)
          end

          it 'should render new' do
            post :create, {education: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end
  end

  describe '#update' do
    let(:college) {
        create(:college, name: 'Aristotle University of Thessaloniki')
      }

      let(:education_level){
        create(:education_level, name: 'Associate')
      }
      
      let(:new_attributes) {
        {
          "college_id": college.id,
          "college_other": nil,
          "education_level_id": education_level.id,
          "description": 'This is general description!',
          "start_date": 6.years.ago.to_date,
          "end_date": 3.years.ago.to_date,
          "candidate_id": @candidate.id
        }
      }

      before(:each) do
        @education = create(:education, valid_attributes)
      end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.with valid attribues' do
        it 'should call set_education method' do
          expect(controller).to receive(:set_education).once.and_call_original
          put :update, {id: @education.id, education: new_attributes}
        end

        it 'should correctly assign @education' do
          put :update, {id: @education.id, education: new_attributes}
          expect(assigns(:education)).to eq(@education)
        end

        it 'should update with requested new_attributes' do
          put :update, {id: @education.id, education: new_attributes}
          @education.reload
          expect(@education.college_id).to eq(@college.id)
          expect(@education.education_level_id).to eq(@education_level.id)
          expect(@education.description).to eq("This is general description!")
          expect(@education.start_date).to eq(6.years.ago.to_date)
          expect(@education.end_date).to eq(3.years.ago.to_date)
          expect(@education.candidate_id).to eq(@candidate.id)
        end

        it 'should redirect_to updated education resource path' do
          put :update, {id: @education.id, education: new_attributes}
          expect(response).to redirect_to(education_path(@education.id))
        end
      end

      context '.with invalid_attributes' do
        pending("Pending validations") do
          it 'should properly assign @education' do
            put :update, {id: @education.id, education: invalid_attributes}
            expect(assigns(:education)).to eq(@education)
          end

          it "re-renders the 'edit' template" do
            put :update, {id: @education.to_param, education: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        put :update, {id: @education.id, education: new_attributes}
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      context '.with valid attribues' do
        it 'should call set_education method' do
          expect(controller).to receive(:set_education).once.and_call_original
          put :update, {id: @education.id, education: new_attributes}
        end

        it 'should correctly assign @education' do
          put :update, {id: @education.id, education: new_attributes}
          expect(assigns(:education)).to eq(@education)
        end

        it 'should update with requested new_attributes' do
          put :update, {id: @education.id, education: new_attributes}
          @education.reload
          expect(@education.college_id).to eq(@college.id)
          expect(@education.education_level_id).to eq(@education_level.id)
          expect(@education.description).to eq("This is general description!")
          expect(@education.start_date).to eq(6.years.ago.to_date)
          expect(@education.end_date).to eq(3.years.ago.to_date)
          expect(@education.candidate_id).to eq(@candidate.id)
        end

        it 'should redirect_to updated education resource path' do
          put :update, {id: @education.id, education: new_attributes}
          expect(response).to redirect_to(education_path(@education.id))
        end
      end

      context '.with invalid_attributes' do
        pending("Pending validations") do
          it 'should properly assign @education' do
            put :update, {id: @education.id, education: invalid_attributes}
            expect(assigns(:education)).to eq(@education)
          end

          it "re-renders the 'edit' template" do
            put :update, {id: @education.to_param, education: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        put :update, {id: @education_level.id, education_level: valid_attributes}
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @education = create(:education)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        delete :destroy, id: @education.id
      end

      it 'should correctly assign @education' do
        delete :destroy, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should delete requested education record' do
        expect{delete :destroy, id: @education}.to change(Education, :count).by(-1)
      end

      it 'should redirect_to educations_url after destroy' do
        delete :destroy, id: @education.id
        expect(response).to redirect_to(educations_url)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        delete :destroy, id: @education.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        delete :destroy, id: @education.id
      end

      it 'should correctly assign @education' do
        delete :destroy, id: @education.id
        expect(assigns(:education)).to eq(@education)
      end

      it 'should delete requested education record' do
        expect{delete :destroy, id: @education}.to change(Education, :count).by(-1)
      end

      it 'should redirect_to educations_url after destroy' do
        delete :destroy, id: @education.id
        expect(response).to redirect_to(educations_url)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        delete :destroy, id: @education_level.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
