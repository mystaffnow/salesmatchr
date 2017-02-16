# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  employer_id        :integer
#  job_id             :integer
#  amount             :decimal(18, 4)
#  stripe_card_token  :string
#  stripe_customer_id :string
#  stripe_charge_id   :string
#  status             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Payment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
