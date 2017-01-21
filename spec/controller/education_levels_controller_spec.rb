require 'rails_helper'

RSpec.describe EducationLevelsController, :type => :controller do
  before(:each) do
    @candidate = create(:candidate, archetype_score: 200)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Witchia', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
  end

  let(:valid_attributes) {
    {
      "name": 'High School'
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
      before {sign_in(@candidate)}

      it 'should correctly assign @education_levels' do
        @education_level = create(:education_level)
        get :index
        expect(assigns(:education_levels)).to eq([@education_level])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @education_levels' do
        @education_level = create(:education_level)
        get :index
        expect(assigns(:education_levels)).to eq([@education_level])
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
      @education_level = create(:education_level)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        get :show, id: @education_level.id
      end

      it 'should correctly assign @education_level' do
        get :show, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @education_level.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        get :show, id: @education_level.id
      end

      it 'should correctly assign @education_level' do
        get :show, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @education_level.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#new" do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @education_level' do
        get :new
        expect(assigns(:education_level)).to be_a_new(EducationLevel)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :new
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @education_level' do
        get :new
        expect(assigns(:education_level)).to be_a_new(EducationLevel)
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
      @education_level = create(:education_level)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @education_level' do
        get :edit, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        get :edit, id: @education_level.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :edit, id: @education_level.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @education_level' do
        get :edit, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        get :edit, id: @education_level.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :edit, id: @education_level.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#create' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.with valid attributes' do
        it 'should create a new EducationLevel' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
        end

        it 'should correctly assign @education_level' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
          expect(assigns(:education_level)).to eq(EducationLevel.first)
        end

        it 'should redirect to created education_level' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
          expect(response).to redirect_to(education_level_path(EducationLevel.first))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it "should correctly assign @education_level" do
            post :create, {education_level: invalid_attributes}
            expect(assigns(:education_level)).to be_a_new(EducationLevel)
          end

          it "re-renders the 'new' template" do
            post :create, {education_level: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      context '.with valid attributes' do
        it 'should create a new EducationLevel' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
        end

        it 'should correctly assign @education_level' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
          expect(assigns(:education_level)).to eq(EducationLevel.first)
        end

        it 'should redirect to created education_level' do
          post :create, {education_level: valid_attributes}
          expect(EducationLevel.count).to eq(1)
          expect(response).to redirect_to(education_level_path(EducationLevel.first))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it "should correctly assign @education_level" do
            post :create, {education_level: invalid_attributes}
            expect(assigns(:education_level)).to be_a_new(EducationLevel)
          end

          it "re-renders the 'new' template" do
            post :create, {education_level: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end
  end

  describe '#update' do
    before(:each) do
      @education_level = create(:education_level, valid_attributes)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.with valid attributes' do
        let(:new_attributes) {
          {name: 'Masters'}
        }

        it 'should correctly assign @education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          expect(assigns(:education_level)).to eq(@education_level)
        end

        it 'should update requested education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          @education_level.reload
          expect(@education_level.name).to eq("Masters")
        end

        it 'should redirect to updated education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          expect(response).to redirect_to(education_level_path(@education_level))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it 'should correctly assign @education_level' do
            put :update, {id: @education_level.id, education_level: invalid_attributes}
            expect(assigns(:education_level)).to eq(@education_level)
          end

          it "re-renders the 'edit' template" do
            education_level = create(:education_level, valid_attributes)
            put :update, {id: education_level.to_param, education_level: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        put :update, {id: @education_level.id, education_level: valid_attributes}
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      context '.with valid attributes' do
        let(:new_attributes) {
          {name: 'Masters'}
        }

        it 'should correctly assign @education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          expect(assigns(:education_level)).to eq(@education_level)
        end

        it 'should update requested education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          @education_level.reload
          expect(@education_level.name).to eq("Masters")
        end

        it 'should redirect to updated education_level' do
          put :update, {id: @education_level.id, education_level: new_attributes}
          expect(response).to redirect_to(education_level_path(@education_level))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it 'should correctly assign @education_level' do
            put :update, {id: @education_level.id, education_level: invalid_attributes}
            expect(assigns(:education_level)).to eq(@education_level)
          end

          it "re-renders the 'edit' template" do
            education_level = create(:education_level, valid_attributes)
            put :update, {id: education_level.to_param, education_level: invalid_attributes}
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
      @education_level = create(:education_level)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        delete :destroy, id: @education_level.id
      end

      it 'should correctly assign @education_level' do
        delete :destroy, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should delete requested education_level record' do
        expect{delete :destroy, id: @education_level.id}.to change(EducationLevel, :count).by(-1)
      end

      it 'should redirect to education_levels_url' do
        delete :destroy, id: @education_level.id
        expect(response).to redirect_to(education_levels_url)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        delete :destroy, id: @education_level.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_education_level method' do
        expect(controller).to receive(:set_education_level).once.and_call_original

        delete :destroy, id: @education_level.id
      end

      it 'should correctly assign @education_level' do
        delete :destroy, id: @education_level.id
        expect(assigns(:education_level)).to eq(@education_level)
      end

      it 'should delete requested education_level record' do
        expect{delete :destroy, id: @education_level.id}.to change(EducationLevel, :count).by(-1)
      end

      it 'should redirect to education_levels_url' do
        delete :destroy, id: @education_level.id
        expect(response).to redirect_to(education_levels_url)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        delete :destroy, id: @education_level.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end
