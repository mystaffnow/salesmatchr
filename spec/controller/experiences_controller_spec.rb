require 'rails_helper'

RSpec.describe ExperiencesController, :type => :controller do
  let(:candidate) {create(:candidate, archetype_score: 200)}
  let(:state) {create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:employer_profile) {create(:employer_profile, employer_id: employer.id, state_id: state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org')}
  let(:sales_type) {create(:sales_type)}
  let(:experience) {
    create(:experience,
            position: "Sales Manager",
            company: "Abc Inc.",
            description: "This is general description",
            start_date: 1.years.ago.to_date,
            end_date: Date.today,
            sales_type_id: sales_type.id,
            candidate_id: candidate.id,
         )
    }

  describe '#destroy' do
    context '.when candidate is sign_in' do
      before {sign_in(candidate)}

      it 'should call set_experience method' do
        expect(controller).to receive(:set_experience).once.and_call_original

        delete :destroy, id: experience.id
      end

      it 'should correctly assign experience' do
        delete :destroy, id: experience.id
        expect(assigns(:experience)).to eq(experience)
      end

      it 'should delete requested experience record' do
        expect{delete :destroy, id: experience.id}.to change(Experience, :count).by(0)
      end

      it 'should redirect to candidates profile page' do
        delete :destroy, id: experience.id
        expect(response).to redirect_to(candidates_profile_path(candidate.id))
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        delete :destroy, id: experience.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {sign_in(employer)}

      it 'should redirects to candidates sign_in page' do
        delete :destroy, id: experience.id
        expect(Experience.count).to eq(1)
        expect(Experience.last).to eq(experience)
      end
    end
  end
end