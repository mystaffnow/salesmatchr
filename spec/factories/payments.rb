# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  employer_id       :integer
#  job_id            :integer
#  amount            :decimal(18, 4)
#  stripe_card_token :string
#  stripe_charge_id  :string
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customer_id       :integer
#

FactoryGirl.define do
  factory :payment do
    amount 1.5
    stripe_card_token "MyString"
    stripe_customer_id "MyString"
    stripe_charge_id "MyString"
    payment_status "MyString"
  end
end
