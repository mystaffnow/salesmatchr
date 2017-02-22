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
#  is_incognito         :boolean
#  linkedin_picture_url :string
#  avatar_file_name     :string
#  avatar_content_type  :string
#  avatar_file_size     :integer
#  avatar_updated_at    :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe CandidateProfile, type: :model do
	let(:state) {create(:state)}
	let(:education_level) {create(:education_level)}
	let(:candidate) {create(:candidate, :first_name => "test", :last_name => "candidate")}
	let(:candidate_profile) {create(:candidate_profile,
																 :candidate_id => candidate.id,
																 :state_id => state.id,
																 :education_level_id => education_level.id
																 )}

	describe '.validation' do
		it { should validate_uniqueness_of(:candidate_id)}
	end

  describe "Association" do
		it {should belong_to :candidate}
		it {should belong_to :state}
		it {should belong_to :education_level}
	end

	describe "Paperclip avatar" do
		it { should have_attached_file(:avatar) }
	  it { should validate_attachment_content_type(:avatar).
	  	allowing('image/jpg', 'image/png', 'image/gif').
	  	rejecting('text/plain', 'text/xml') }
	  
	  context '.shoulda matcher' do
	  	it 'should return default avatar' do
	  		expect(candidate_profile.avatar_url).to eq('/img/missing.png')
	  	end
	  end
	end
end
	