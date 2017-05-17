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

class Customer < ActiveRecord::Base
  # association
  belongs_to :employer

  # validates
  validates :employer_id, :stripe_card_token, :stripe_customer_id,
           :last4, :card_holder_name, :exp_month,
           :exp_year, presence: true
  validates :employer_id, uniqueness: { scope: :last4 }

  # return true if card is expired
  def card_is_expired?
    return true if (self.exp_month <= Time.now.month && self.exp_year <= Time.now.year)
    return false
  end
end
