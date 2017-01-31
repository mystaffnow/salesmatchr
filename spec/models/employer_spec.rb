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

require 'rails_helper'

RSpec.describe Employer do
  let(:employer) {create(:employer, :first_name => "test", :last_name => "employer")}
  let(:state) {create(:state)}
  
  describe "Association" do
    it {should belong_to :state}
    it {should have_many :jobs}
  end

  describe "Paperclip avatar" do
    it { should have_attached_file(:avatar) }
    it { should validate_attachment_content_type(:avatar).
      allowing('image/jpg', 'image/png', 'image/gif').
      rejecting('text/plain', 'text/xml') }
      
    it 'should return default avatar' do
      expect(employer.avatar.url).to eq('/img/missing.png')
    end
  end

  it 'should return full_name of employer' do
    expect(employer.name).to eq('test employer')
  end
  
  context '.can_proceed' do
    before(:each) do
      @employer = create(:employer, :state_id => state.id, :first_name => "test", :last_name => "employer", :city => 'Sherwood', :zip => '97140', :website => 'http://www.mywebsite.com')
    end

    it 'should return true' do
      expect(@employer.can_proceed).to be_truthy
    end

    it 'should return false without state' do
      @employer.state = nil
      expect(@employer.can_proceed).to be_falsey
    end

    it 'should return false without name' do
      @employer.first_name = nil
      @employer.last_name = nil
      expect(@employer.can_proceed).to be_falsey
    end

    it 'should return false without city' do
      @employer.city = nil
      expect(@employer.can_proceed).to be_falsey
    end

    it 'should return false without zip' do
      @employer.zip = nil
      expect(@employer.can_proceed).to be_falsey
    end

    it 'should return false without website' do
      @employer.website = nil
      expect(@employer.can_proceed).to be_falsey
    end
  end
end
