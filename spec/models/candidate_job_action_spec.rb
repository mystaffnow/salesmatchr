require 'rails_helper'

RSpec.describe CandidateJobAction do
  describe "Association" do
    it {should belong_to :candidate}
    it {should belong_to :job}
  end
end