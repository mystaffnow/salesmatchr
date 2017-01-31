# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  employer_id      :integer
#  salary_low       :integer
#  salary_high      :integer
#  zip              :string
#  is_remote        :boolean
#  title            :string
#  description      :text
#  is_active        :boolean          default(FALSE)
#  view_count       :integer
#  state_id         :integer
#  city             :string
#  archetype_low    :integer
#  archetype_high   :integer
#  job_function_id  :integer
#  latitude         :float
#  longitude        :float
#  stripe_token     :string
#  experience_years :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
