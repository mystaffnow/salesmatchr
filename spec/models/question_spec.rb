require 'rails_helper'

RSpec.describe Question do
  describe "Association" do
    it {should have_many :answers}
  end

  context 'nested attributes' do
    it{ should accept_nested_attributes_for(:answers).allow_destroy(true) }
  end
end