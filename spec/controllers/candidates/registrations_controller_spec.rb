require 'rails_helper'

RSpec.describe Candidates::RegistrationsController, :type => :controller do
  describe '#create' do
    let(:valid_attributes) {
      {
        "first_name"=>"user45", "last_name"=>"cast", "email"=>"user45@gmail.com", "password"=>"111111111", "password_confirmation"=>"111111111"
      }
    }

    let(:invalid_attributes) {
      {id: 1}
    }

    before{@request.env["devise.mapping"] = Devise.mappings[:candidate]}

    context '.with valid attributes' do
      it 'should create an candidate' do
        post :create, {candidate: valid_attributes}
        expect(Candidate.count).to eq(1)
        expect(Candidate.first.first_name).to eq("user45")
      end
    end

    context '.with invalid_attributes' do
      it 'should not create an candidate' do
         post :create, {candidate: invalid_attributes}
         expect(Candidate.last).to eq(nil)
         expect(Candidate.count).to eq(0)
      end
    end
  end
end