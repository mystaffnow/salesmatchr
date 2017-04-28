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
#

class Customer < ActiveRecord::Base
  # association
  belongs_to :employer

  # validates
  validates :employer_id, :stripe_card_token, :stripe_customer_id, :last4, presence: true
  validates :employer_id, uniqueness: true
end
