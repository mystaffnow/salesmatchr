# == Schema Information
#
# Table name: candidate_profiles
#
#  id                   :integer          not null, primary key
#  candidate_id         :integer
#  city                 :string
#  state_id             :integer
#  zip                  :string
#  education_level_id   :integer
#  ziggeo_token         :string
#  is_incognito         :boolean          default(TRUE)
#  linkedin_picture_url :string
#  avatar_file_name     :string
#  avatar_content_type  :string
#  avatar_file_size     :integer
#  avatar_updated_at    :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :candidate_profile do
    city 'test city'
		zip '10500'
  end
end
