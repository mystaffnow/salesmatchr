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

class Payment < ActiveRecord::Base
	belongs_to :job
	belongs_to :employer

	enum status: ['charged']
end
