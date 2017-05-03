# == Schema Information
#
# Table name: employers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  company                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

require 'rails_helper'

RSpec.describe Employer do
  let(:employer) {create(:employer, :first_name => "test", :last_name => "employer")}
  let(:state) {create(:state)}

  describe "Validation" do
    it {should validate_presence_of(:first_name)}
    it {should validate_presence_of(:last_name)}
    it {should validate_presence_of(:company)}
  end

  describe '.nested attributes' do
    it {should accept_nested_attributes_for(:employer_profile)}
  end
  
  describe "Association" do
    it {should have_one(:employer_profile).dependent(:destroy)}
    it {should have_many(:jobs).dependent(:destroy)}
    it {should have_many(:customers).dependent(:destroy)}
    it {should have_many(:payments).dependent(:destroy)}
  end

  it 'should build profile automatically' do
    @employer = create(:employer)
    @employer.reload
    expect(@employer.employer_profile).to be_a(EmployerProfile)
    expect(@employer.employer_profile.employer_id).to eq(@employer.id)
    expect(@employer.employer_profile.city).to be_nil
  end

  it 'should not build employer profile when already there' do
    @employer = build(:employer)
    @employer.employer_profile = build(:employer_profile)
    @employer.save
    expect(Employer.count).to eq(1)
    expect(EmployerProfile.count).to eq(1)
    expect(EmployerProfile.first.employer_id).to eq(@employer.id)
    expect(EmployerProfile.first.city).to eq("my city")
  end

  it 'should return full_name of employer' do
    expect(employer.name).to eq('test employer')
  end

  it '#is_owner_of?' do
    @employer = employer
    EmployerProfile.first.update(employer_id: @employer.id)
    expect(@employer.is_owner_of?(EmployerProfile.first)).to be_truthy
  end
  
  context '.can_proceed' do
    it 'should return true' do
      @employer = create(:employer)
      @profile1 = EmployerProfile.first
      @profile1.update_attributes(:state_id => state.id, :city => 'Sherwood', :zip => '97140', :website => 'http://www.mywebsite.com')
      @profile1.reload
      expect(Employer.first.can_proceed).to be_truthy
    end

    it 'should return false without state' do
      @employer1 = create(:employer)
      expect(@employer1.can_proceed).to be_falsey
    end

    it 'should return false without name' do
      employer.first_name = nil
      employer.last_name = nil
      expect(employer.can_proceed).to be_falsey
    end

    it 'should return false without city' do
      @employer1 = create(:employer)
      expect(@employer1.can_proceed).to be_falsey
    end

    it 'should return false without zip' do
      expect(employer.can_proceed).to be_falsey
    end

    it 'should return false without website' do
      expect(employer.can_proceed).to be_falsey
    end
  end

  it '#selected_card' do
    stripe_card_token = generate_stripe_card_token
    stripe_customer_id = generate_stripe_customer(stripe_card_token)
    customer = create(:customer, stripe_card_token: stripe_card_token,
                                 stripe_customer_id: stripe_customer_id,
                                 employer_id: employer.id)
    expect(employer.selected_card).to eq(customer)
  end
end
