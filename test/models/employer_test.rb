# == Schema Information
#
# Table name: employers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  company                :string
#  state_id               :integer
#  city                   :string
#  zip                    :string
#  description            :string
#  website                :string
#  ziggeo_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

require 'test_helper'

class EmployerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
