require 'rails_helper'

RSpec.describe Employers::RegistrationsController, :type => :controller do
  describe '#create' do
    let(:valid_attributes) {
      {
        "first_name"=>"user45", "last_name"=>"cast", "company"=>"abc", "email"=>"user45@gmail.com", "password"=>"111111111", "password_confirmation"=>"111111111"
      }
    }

    let(:invalid_attributes) {
      {id: 1}
    }

    before{@request.env["devise.mapping"] = Devise.mappings[:employer]}

    context '.with valid attributes' do
      it 'should create an employer' do
        post :create, {employer: valid_attributes}
        expect(Employer.count).to eq(1)
        expect(Employer.first.first_name).to eq("user45")
      end
    end

    context '.with invalid_attributes' do
      it 'should not create an employer' do
         post :create, {employer: invalid_attributes}
         expect(Employer.last).to eq(nil)
         expect(Employer.count).to eq(0)
      end
    end
  end
end