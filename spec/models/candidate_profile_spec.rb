# == Schema Information
#
# Table name: candidate_profiles
#
#  id                           :integer          not null, primary key
#  candidate_id                 :integer
#  city                         :string
#  state_id                     :integer
#  zip                          :string
#  education_level_id           :integer
#  ziggeo_token                 :string
#  is_incognito                 :boolean          default(TRUE)
#  linkedin_picture_url         :string
#  avatar_file_name             :string
#  avatar_content_type          :string
#  avatar_file_size             :integer
#  avatar_updated_at            :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  is_active_match_subscription :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe CandidateProfile, type: :model do
	let(:state) {create(:state)}
	let(:education_level) {create(:education_level)}
	let(:candidate) {create(:candidate, :first_name => "test", :last_name => "candidate")}

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
	  	rejecting('text/plain', 'text/xml')
	  	 }

  	it 'should return default incognito image when incognito ON, avatar nil' do
  		candidate
  		expect(CandidateProfile.first.avatar_url).to eq('/img/incognito.png')
  	end

  	it 'should return missing image when incognito OFF, avatar nil' do
  		candidate
  		CandidateProfile.first.update(is_incognito: false)
  		expect(CandidateProfile.count).to eq(1)
  		expect(CandidateProfile.first.is_incognito).to be_falsy
  		expect(CandidateProfile.first.avatar_url).to eq('/img/missing.png')
  	end

  	it 'should return image when incognito OFF, avatar present' do
  		candidate
  		file = File.open("public/img/Graphic2.png")
  		profile = CandidateProfile.first
  		profile.update_attributes(is_incognito: false, avatar: file)
  		profile.save
  		expect(CandidateProfile.first.avatar_file_name).to eq('Graphic2.png')
  	end

    it 'should have job matching email alert setting ON by default' do
      candidate
      expect(CandidateProfile.first.is_active_match_subscription).to be_truthy
    end
	end
end
