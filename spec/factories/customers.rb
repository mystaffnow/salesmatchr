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

FactoryGirl.define do
  factory :customer do
    employer_id 1
    stripe_card_token "tok_1X4o93YoWV3K0HedHthku2Z"
    stripe_customer_id "cus_SShOhdOXXXS6fI"
    last4 '4242'
    card_holder_name 'Test user'
    exp_month 1.years.from_now.month
    exp_year 1.years.from_now.year
    is_selected true
  end
end
