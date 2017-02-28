require 'rails_helper'

RSpec.describe EmployersController, :type => :controller do
  let(:candidate) {create(:candidate, archetype_score: 200)}
  let(:state) {create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}

  describe '#profile' do
    context '.when candidate is signed in' do
      before { sign_in(candidate)}
      
      it 'should redirect_to employers sign_in page' do
        get :profile
        expect(response).to redirect_to("/employers/sign_in")
      end
    end
    # context '.when employer is signed in' do
    #   before { sign_in(employer)}

    #   it 'should redirect to /employers/account' do
    #     employer_profile.update(zip: nil, state_id: nil, city: nil, website: nil)
    #     get :profile
    #     expect(response).to redirect_to("/employers/account")
    #   end
    # end
  end

  describe 'GET#account' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :account
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    # context '.when employer is signed in' do
    #   before { sign_in(employer) }
    #   it 'should not call check_employer and should not redirect to /employers/account' do
    #     employer.update(first_name: nil, last_name: nil)
    #     employer_profile.update(zip: nil, state_id: nil, city: nil, website: nil)
    #     get :account
    #     expect(response).not_to redirect_to("/employers/account")
    #   end
    # end
  end

  describe 'PUT#account' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }
      it 'should redirect_to employers sign_in page' do
        put :account
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    # context '.when employer is signed in' do
    #   before { sign_in(employer) }
    #   it 'should not call check_employer and should not redirect to /employers/account' do
    #     employer.update(first_name: nil, last_name: nil)
    #     employer_profile.update(zip: nil, state_id: nil, city: nil, website: nil)
    #     put :account
    #     expect(response).not_to redirect_to("/employers/account")
    #   end
    # end
  end

  describe '#public' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should correctly assign employer' do
        get :public, id: employer.id
        expect(assigns(:employer)).to eq(employer)
      end
      
      # it 'should redirect to candidates_archetype_path' do
      #   candidate.update(archetype_score: nil)
      #   get :public, id: candidate.id
      #   expect(response).to redirect_to(candidates_archetype_path)
      # end
    end

    context '.when employer is signed in' do
      before {sign_in(employer)}

      it 'should correctly assign employer' do
        employer_profile(employer)
        get :public, id: employer.id
        expect(assigns(:employer)).to eq(employer)
      end

      # it 'should redirect to /employers/account' do
      #   employer.update(first_name: nil, last_name: nil)
      #   employer_profile.update(zip: nil, state_id: nil, city: nil, website: nil)
      #   get :public, id: candidate.id
      #   expect(response).to redirect_to("/employers/account")
      # end
    end
  end

  describe '#update' do
    let(:new_attributes){
      {
        "website": "www.example.com",
        "ziggeo_token": "nil",
        "avatar": nil,
        "zip": 1050,
        "city": 'Wichita',
        "state_id": state.id,
        "description": "This is general description!"
      }
    }

    let(:invalid_attributes){
      {
        "params": {
          id: 1
        }
      }
    }

    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        put :update, { employer_profile: new_attributes }
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { sign_in(employer)}

      context 'with valid params'
        it 'should update employer profile with requested parameters' do
          put :update, { employer_profile: new_attributes }
          expect(EmployerProfile.last.website).to eq("www.example.com")
        end

        it 'should redirect_to employers_profile_path after update' do
          put :update, { employer_profile: new_attributes }
          expect(response).to redirect_to(employers_profile_path) 
        end

        # it 'should not call check_employer and should not redirect to /employers/account' do
        #   employer.update(first_name: nil, last_name: nil)
        #   employer_profile.update(zip: nil, state_id: nil, city: nil, website: nil)
        #   put :update, { employer_profile: new_attributes }
        #   expect(response).not_to redirect_to("/employers/account")
        # end
      end

      context 'with invalid params' do
        pending("Pending Validation") do
          before { sign_in(employer)}
          it 'should render account page' do
            put :update, { employer_profile: invalid_attributes }
            expect(response).to render_template("account")
          end
        end
      end
  end
end