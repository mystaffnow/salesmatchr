require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
	controller do
    def index
      render text: 'Success'
    end
	end

	context "when signed in candidate" do
		before do
			@candidate = create(:candidate, archetype_score: nil)
			sign_in @candidate
		end

		it 'should redirect to candidates_archetype_path' do
			get :index
			expect(Candidate.count).to eq(1)
			expect(CandidateProfile.count).to eq(1)
			expect(CandidateProfile.first.candidate_id).to eq(@candidate.id)
			expect(Candidate.first.archetype_score).to eq(nil)
			expect(response.status).to eq(302)
			expect(response).to redirect_to(candidates_archetype_path)
		end

		it 'should call index action' do
			@candidate.update(archetype_score: 5)
			@candidate.reload
			get :index
			expect(response.status).to eq(200)
			expect(response.body).to eq("Success")
		end
	end

	context "when signed in employer" do
		before do
			@employer = create(:employer)
			sign_in @employer
		end

		it 'should redirect to employers_account_path' do
			get :index
			expect(Employer.count).to eq(1)
			expect(EmployerProfile.count).to eq(1)
			expect(EmployerProfile.first.employer_id).to eq(@employer.id)
			expect(response).to redirect_to(employers_account_path)
			expect(response.status).to eq(302)
		end

		it 'should call index action' do
			@state = create(:state)
			EmployerProfile.first.update(city: 'test city', zip: 10200, state_id: @state.id, website: 'www.test.example.com')
			get :index
			expect(response.status).to eq(200)
			expect(response.body).to eq("Success")
		end
	end
end