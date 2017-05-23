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

class Payment < ActiveRecord::Base
  # association
	belongs_to :job
	belongs_to :employer

  # validation
  validates_presence_of :employer_id, :job_id, :amount,
                        :stripe_charge_id, :customer_id

	enum status: ['charged']
end
