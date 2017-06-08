require 'rails_helper'

RSpec.describe CandidatePolicy do
  subject { described_class }

  let(:candidate) {create(:candidate)}

  permissions :archetype?, :account?, :update?, :update_archetype?, :archetype_result?,
              :incognito?, :subscription? do
    it 'denies access when candidate is archived' do
      candidate
      candidate.update(deleted_at: Time.now)
      expect(Candidate.first.deleted_at).not_to be_nil
      expect(subject).not_to permit(candidate, Candidate.first)
    end

    it 'grant access when candidate is not archived' do
      candidate
      expect(Candidate.first.deleted_at).to be_nil
      expect(subject).to permit(candidate, Candidate.first)
    end
  end
end