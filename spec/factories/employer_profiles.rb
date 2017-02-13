# == Schema Information
#
# Table name: employer_profiles
#
#  id                  :integer          not null, primary key
#  employer_id         :integer
#  website             :string
#  ziggeo_token        :string
#  zip                 :string
#  city                :string
#  state_id            :integer
#  description         :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :employer_profile do
    website 'www.example.com'
    zip '10500'
    city 'my city'
    description 'this is general description!'
  end
end
