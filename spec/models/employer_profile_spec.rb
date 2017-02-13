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

require 'rails_helper'

RSpec.describe EmployerProfile, type: :model do
	let(:employer) {create(:employer, :first_name => "test", :last_name => "employer")}
	let(:state) {create(:state)}

  describe "Association" do
    it {should belong_to(:employer)}
    it {should belong_to(:state)}
  end

  describe "Paperclip avatar" do
    it { should have_attached_file(:avatar) }
    it { should validate_attachment_content_type(:avatar).
      allowing('image/jpg', 'image/png', 'image/gif').
      rejecting('text/plain', 'text/xml') }
      
    it 'should return default avatar' do
			@employer_profile = create(:employer_profile, employer_id: employer.id,
															state_id: state.id
															)
      expect(employer.employer_profile.avatar.url).to eq('/img/missing.png')
    end
  end
end
