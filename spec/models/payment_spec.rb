# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  employer_id      :integer
#  job_id           :integer
#  amount           :decimal(18, 4)
#  stripe_charge_id :string
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_id      :integer
#

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'Association' do
  	it {should belong_to :job}
  	it {should belong_to :employer}
  end

  describe 'Validation' do
    it {should validate_presence_of :employer_id}
    it {should validate_presence_of :job_id}
    it {should validate_presence_of :amount}
    it {should validate_presence_of :stripe_charge_id}
    it {should validate_presence_of :customer_id}
  end

  it 'require enum status' do
  	expect(Payment.statuses).to eq({"charged"=>0})
  end
end
