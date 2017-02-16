# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  amount             :float
#  employer_id        :integer
#  job_id             :integer
#  stripe_card_token  :string
#  stripe_customer_id :string
#  stripe_charge_id   :string
#  payment_status     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Payment < ActiveRecord::Base
	belongs_to :job

	enum status: ['charged']
end
