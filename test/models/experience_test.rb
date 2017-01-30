# == Schema Information
#
# Table name: experiences
#
#  id            :integer          not null, primary key
#  position      :string
#  company       :string
#  description   :string
#  start_date    :date
#  end_date      :date
#  is_current    :boolean
#  is_sales      :boolean
#  sales_type_id :integer
#  candidate_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ExperienceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
