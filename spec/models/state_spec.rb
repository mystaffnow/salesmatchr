require 'rails_helper'

RSpec.describe State do
  describe 'association' do
    it {should have_many :candidates}
  end
end