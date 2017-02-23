require 'rails_helper'

RSpec.describe EducationsController, :type => :controller do
  let(:candidate) { create(:candidate, archetype_score: 200)}
  let(:state) { create(:state)}
  let(:employer) {create(:employer, first_name: 'user', last_name: 'test')}
  let(:employer_profile) { create(:employer_profile, employer_id: @employer.id, state_id: @state.id, city: 'Wichita', zip: 5520, website: 'www.mywebsite.org') }
  let(:college) { create(:college)}
  let(:education_level) { create(:education_level)}
  let(:education) { create(:education, education_level_id: education_level.id, college_id: college.id, candidate_id: candidate.id)}

  describe '#destroy' do
    context '.when candidate is sign_in' do
      before do
        sign_in candidate
      end

      it 'should call set_education method' do
        expect(controller).to receive(:set_education).once.and_call_original
        delete :destroy, id: education.id
      end

      context 'After education is destroyed' do
        before { delete :destroy, id: education.id }

        it {expect(assigns(:education)).to eq(education)}
        it {expect(Education.count).to eq(0)}
        it {expect(response).to redirect_to(candidates_profile_path(candidate.id))}
      end

      it 'should redirect to candidates_archetype_path' do
        candidate.update(archetype_score: nil)
        delete :destroy, id: education.id
        expect(response).to redirect_to(candidates_archetype_path)
      end
    end

    context '.when employer is sign_in' do
      before {
        sign_in(employer)
        delete :destroy, id: education.id
      }

      it 'should redirects to candidates sign_in page' do
        expect(Education.count).to eq(1)
        expect(Education.last).to eq(education)
      end
    end
  end
end
