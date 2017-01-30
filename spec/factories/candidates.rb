# == Schema Information
#
# Table name: candidates
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  city                   :string
#  state_id               :integer
#  zip                    :string
#  education_level_id     :integer
#  archetype_score        :integer
#  ziggeo_token           :string
#  uid                    :string
#  provider               :string
#  is_incognito           :boolean
#  year_experience_id     :integer
#  linkedin_picture_url   :string
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
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

FactoryGirl.define do
	factory :candidate do
		first_name 'test'
		last_name 'candidate'
		sequence(:email) {|i| "test#{i}@example.com"}
		password 'password'
	end
end
