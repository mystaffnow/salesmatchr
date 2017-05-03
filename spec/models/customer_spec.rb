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
#  card_number        :string
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
    it {should validate_presence_of :card_number}
    it {should validate_uniqueness_of :card_number}
  end

  describe 'association' do
    it {should belong_to :employer}
  end
end
