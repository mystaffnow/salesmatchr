require 'rails_helper'

RSpec.describe ExperiencesController, :type => :controller do
  before(:each) do
    @candidate = create(:candidate, archetype_score: 200)
    @state = create(:state)
    @employer = create(:employer, state_id: @state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org', first_name: 'user', last_name: 'test')
  end

  let(:valid_attributes) {
    {
      position: "web developer",
      company: "Abc  Inc",
      description: "this is description",
      start_date: 3.years.ago,
      end_date: 1.years.ago,
      is_current: true,
      is_sales: nil,
      sales_type_id: 3,
      candidate_id: 2
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

      it 'should assign @experiences' do
        @experience = create(:experience)
        get :index
        expect(assigns(:experiences)).to eq([@experience])
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :index
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should assign @experiences' do
        @experience = create(:experience)
        get :index
        expect(assigns(:experiences)).to eq([@experience])
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
      @experience = create(:experience)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        get :show, id: @experience.id
      end

      it 'should correctly assign @experience' do
        get :show, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :show, id: @experience.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        get :show, id: @experience.id
      end

      it 'should correctly assign @experience' do
        get :show, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :show, id: @experience.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#new" do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @experience' do
        get :new
        expect(assigns(:experience)).to be_a_new(Experience)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :new
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @experience' do
        get :new
        expect(assigns(:experience)).to be_a_new(Experience)
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
      @experience = create(:experience)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should correctly assign @experience' do
        get :edit, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        get :edit, id: @experience.id
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        get :edit, id: @experience.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should correctly assign @experience' do
        get :edit, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        get :edit, id: @experience.id
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        get :edit, id: @experience.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#create' do
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.with valid attributes' do
        it 'should create a new Experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
        end

        it 'should correctly assign @experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
          expect(assigns(:experience)).to eq(Experience.first)
        end

        it 'should redirect to created experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
          expect(response).to redirect_to(experience_path(Experience.first))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it "should correctly assign @experience" do
            post :create, {experience: invalid_attributes}
            expect(assigns(:experience)).to be_a_new(Experience)
          end

          it "re-renders the 'new' template" do
            post :create, {experience: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      context '.with valid attributes' do
        it 'should create a new Experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
        end

        it 'should correctly assign @experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
          expect(assigns(:experience)).to eq(Experience.first)
        end

        it 'should redirect to created experience' do
          post :create, {experience: valid_attributes}
          expect(Experience.count).to eq(1)
          expect(response).to redirect_to(experience_path(Experience.first))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it "should correctly assign @experience" do
            post :create, {experience: invalid_attributes}
            expect(assigns(:experience)).to be_a_new(Experience)
          end

          it "re-renders the 'new' template" do
            post :create, {experience: invalid_attributes}
            expect(response).to render_template("new")
          end
        end
      end
    end
  end

  describe '#update' do
    before(:each) do
      @experience = create(:experience, valid_attributes)
    end

    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      context '.with valid attributes' do
        let(:new_attributes) {
          {
            position: "marketing manager",
            company: "My company  Inc",
            description: "this is description",
            start_date: 4.years.ago,
            end_date: 4.months.ago,
            is_current: false,
            is_sales: nil,
            sales_type_id: 3,
            candidate_id: 2
          }
        }

        it 'should correctly assign @experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          expect(assigns(:experience)).to eq(@experience)
        end

        it 'should call set_experience method' do
          expect(controller).to receive(:set_experience).once.and_call_original

          put :update, {id: @experience.id, experience: new_attributes}
        end

        it 'should update requested experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          @experience.reload
          expect(@experience.position).to eq("marketing manager")
          expect(@experience.company).to eq("My company  Inc")
        end

        it 'should redirect to updated experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          expect(response).to redirect_to(experience_path(@experience))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it 'should correctly assign @experience' do
            put :update, {id: @experience.id, experience: invalid_attributes}
            expect(assigns(:experience)).to eq(@experience)
          end

          it "re-renders the 'edit' template" do
            experience = create(:experience, valid_attributes)
            put :update, {id: experience.to_param, experience: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        put :update, {id: @experience.id, experience: valid_attributes}
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      context '.with valid attributes' do
        let(:new_attributes) {
          {
            position: "marketing manager",
            company: "My company  Inc",
            description: "this is description",
            start_date: 4.years.ago,
            end_date: 4.months.ago,
            is_current: false,
            is_sales: nil,
            sales_type_id: 3,
            candidate_id: 2
          }
        }

        it 'should correctly assign @experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          expect(assigns(:experience)).to eq(@experience)
        end

        it 'should update requested experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          @experience.reload
          expect(@experience.position).to eq("marketing manager")
          expect(@experience.company).to eq("My company  Inc")
        end

        it 'should redirect to updated experience' do
          put :update, {id: @experience.id, experience: new_attributes}
          expect(response).to redirect_to(experience_path(@experience))
        end
      end

      context '.with invalid attributes' do
        pending("Pending Validation") do
          it 'should correctly assign @experience' do
            put :update, {id: @experience.id, experience: invalid_attributes}
            expect(assigns(:experience)).to eq(@experience)
          end

          it "re-renders the 'edit' template" do
            experience = create(:experience, valid_attributes)
            put :update, {id: experience.to_param, experience: invalid_attributes}
            expect(response).to render_template("edit")
          end
        end
      end
      
      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        put :update, {id: @experience.id, experience: valid_attributes}
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @experience = create(:experience)
    end
    context '.when candidate is sign_in' do
      before {sign_in(@candidate)}

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        delete :destroy, id: @experience.id
      end

      it 'should correctly assign @experience' do
        delete :destroy, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should delete requested experience record' do
        expect{delete :destroy, id: @experience.id}.to change(Experience, :count).by(-1)
      end

      it 'should redirect to experiences_url' do
        delete :destroy, id: @experience.id
        expect(response).to redirect_to(experiences_url)
      end

      it 'should redirect to candidates_archetype_path' do
        @candidate.update(archetype_score: nil)
        delete :destroy, id: @experience.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(@employer)}

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        delete :destroy, id: @experience.id
      end

      it 'should correctly assign @experience' do
        delete :destroy, id: @experience.id
        expect(assigns(:experience)).to eq(@experience)
      end

      it 'should delete requested experience record' do
        expect{delete :destroy, id: @experience.id}.to change(Experience, :count).by(-1)
      end

      it 'should redirect to experiences_url' do
        delete :destroy, id: @experience.id
        expect(response).to redirect_to(experiences_url)
      end

      it 'should redirect to /employers/account' do
        @employer.update(first_name: nil, last_name: nil, zip: nil, state_id: nil, city: nil, website: nil)
        delete :destroy, id: @experience.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end