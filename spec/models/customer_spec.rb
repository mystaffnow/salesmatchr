# == Schema Information
#
# Table name: customers
#
#  id                 :integer          not null, primary key
#  employer_id        :integer
#  stripe_card_token  :string
#  stripe_customer_id :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  last4              :integer
#  card_holder_name   :string
#  exp_month          :integer
#  exp_year           :integer
#  is_selected        :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '.validation' do
    it {should validate_presence_of :employer_id}
    it {should validate_presence_of :stripe_card_token}
    it {should validate_presence_of :stripe_customer_id}
    it {should validate_presence_of :last4}
    it {should validate_presence_of :card_holder_name}
    it {should validate_presence_of :exp_month}
    it {should validate_presence_of :exp_year}
    it { should validate_uniqueness_of(:employer_id).scoped_to(:last4) }
  end

  describe 'association' do
    it {should belong_to :employer}
  end

  describe '/' do
    let(:state) {create(:state)}
    let(:employer) {create(:employer)}
    let(:job_function) {create(:job_function)}
    let(:job) {
        create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900", 
                     city: 'city1', state_id: state.id,job_function_id: job_function.id, is_active: true, status: Job.statuses["enable"])
              }
    let(:stripe_card_token) {generate_stripe_card_token}
    
    it '#is_card_not_expired?' do
      # constructor
      obj = Services::Pay.new(employer, job, stripe_card_token)
      expect(obj.stripe_card_token).to eq(stripe_card_token)
      # customer
      expect(obj.is_customer_saved?).to be_truthy    
      expect(Customer.count).to eq(1)
      
      Customer.first.update(exp_month: Timecop.freeze(Time.now.month))
      Customer.first.update(exp_year: Timecop.freeze(Time.now.year))
      expect(Customer.first.is_card_not_expired?).to be_truthy

      Customer.first.update(exp_month: 1.years.from_now.month)
      Customer.first.update(exp_year: 1.years.from_now.year)
      expect(Customer.first.is_card_not_expired?).to be_truthy

      Customer.first.update(exp_month: 1.months.ago.month)
      Customer.first.update(exp_year: 1.years.ago.year)
      expect(Customer.first.is_card_not_expired?).to be_falsy
    end
  end
end
