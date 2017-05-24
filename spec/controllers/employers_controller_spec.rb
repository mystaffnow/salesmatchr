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

    context '.when employer is signed in' do
      before {
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should redirect to /employers/account' do
        blank_profile(EmployerProfile.first)
        # EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        get :profile
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe 'GET#account' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :account
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
        }

      it 'should not call check_employer and should not redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        get :account
        expect(response).not_to redirect_to("/employers/account")
      end
    end
  end

  describe 'PUT#account' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }
      it 'should redirect_to employers sign_in page' do
        put :account
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
      }
      
      it 'should not call check_employer and should not redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        put :account
        expect(response).not_to redirect_to("/employers/account")
      end
    end
  end

  describe '#public' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should correctly assign employer' do
        get :public, id: employer.id
        expect(assigns(:employer)).to eq(employer)
      end
      
      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        get :public, id: candidate.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is signed in' do
      before {
        sign_in(employer)
        employer_profile(employer)
      }

      it 'should correctly assign employer' do
        # employer_profile(employer)
        get :public, id: employer.id
        expect(assigns(:employer)).to eq(employer)
      end

      it 'should redirect to /employers/account' do
        blank_profile(EmployerProfile.first)
        # EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        get :public, id: candidate.id
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#update' do
    let(:new_attributes){
      {
        first_name: 'Test',
        last_name: 'User',
        :employer_profile_attributes => {
          "website": "www.example.com",
          "ziggeo_token": "nil",
          "avatar": nil,
          "zip": 1050,
          "city": 'Wichita',
          "state_id": state.id,
          "description": "This is general description!"
        }
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
        put :update, { employer: new_attributes }
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
      }

      context 'with valid params'
        it 'should update employer profile with requested parameters' do
          put :update, { employer: new_attributes }
          expect(EmployerProfile.last.website).to eq("www.example.com")
        end

        it 'should redirect_to employers_profile_path after update' do
          put :update, { employer: new_attributes }
          expect(response).to redirect_to(employers_profile_path) 
        end

        it 'should not call check_employer and should not redirect to /employers/account' do
          EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
          put :update, { employer: new_attributes }
          expect(response).not_to redirect_to("/employers/account")
        end
      end

    context 'with invalid params' do
      pending("Pending Validation") do
        before { sign_in(employer)}
        it 'should render account page' do
          put :update, { employer: invalid_attributes }
          expect(response).to render_template("account")
        end
      end
    end
  end

  describe '#add_payment_method' do
    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :add_payment_method
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
        }

      it 'should assign customer' do
        get :add_payment_method
        expect(assigns(:customer)).to be_a_new(Customer)
      end

      it 'should not call check_employer and should not redirect to /employers/account' do
        blank_profile(EmployerProfile.first)
        # EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        get :add_payment_method
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe '#insert_payment_method' do
    let(:customer_params) {
      {stripe_card_token: generate_stripe_card_token}
    }

    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        post :insert_payment_method, {customer: customer_params}
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
        }

      it 'should create customer details' do
        post :insert_payment_method, {customer: customer_params}
        expect(Employer.count).to eq(1)
        expect(Customer.count).to eq(1)
        expect(Customer.first.employer_id).to eq(Employer.first.id)
        expect(Customer.first.stripe_card_token).not_to be_nil
        expect(Customer.first.stripe_customer_id).not_to be_nil
        expect(Customer.first.last4).not_to be_nil
        expect(response).to redirect_to(employers_payment_methods_path)
      end

      it 'should not call check_employer and should not redirect to /employers/account' do
        blank_profile(EmployerProfile.first)
        # EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        post :insert_payment_method, {customer: customer_params}
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe "#list_payment_method" do
    let(:stripe_card_token) {
       generate_stripe_card_token
    }

    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        post :list_payment_method
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
        }

      it 'should return customer list' do
        pay_service = Services::Pay.new(employer, nil, stripe_card_token)
        pay_service.is_customer_saved?                             
        expect(Customer.count).to eq(1)
      end

      it 'should not call check_employer and should not redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        post :list_payment_method
        expect(response).to redirect_to("/employers/account")
      end
    end
  end

  describe ".choose_payment_method" do
    let(:stripe_card_token) {
      generate_stripe_card_token
    }

    context '.when candidate is signed in' do
      before { sign_in(candidate) }

      it 'should redirect_to employers sign_in page' do
        get :choose_payment_method
        expect(response).to redirect_to("/employers/sign_in")
      end
    end

    context '.when employer is signed in' do
      before { 
        sign_in(employer)
        employer_profile(employer)
        }
      let(:customer) {
        pay_service = Services::Pay.new(employer, nil, stripe_card_token)
        pay_service.is_customer_saved?
      }

      it '' do
        customer                          
        expect(Customer.count).to eq(1)
        expect(Customer.first.is_selected).to be_falsy
        xhr :get, :choose_payment_method, id: Customer.first.id, format: :js
        expect(Customer.first.is_selected).to be_truthy
      end

      it 'should not call check_employer and should not redirect to /employers/account' do
        EmployerProfile.first.update(zip: nil, state_id: nil, city: nil, website: nil)
        customer                            
        expect(Customer.count).to eq(1)
        expect(Customer.first.is_selected).to be_falsy
        xhr :get, :choose_payment_method, id: Customer.first.id, format: :js
        expect(response).to redirect_to("/employers/account")
      end
    end
  end
end