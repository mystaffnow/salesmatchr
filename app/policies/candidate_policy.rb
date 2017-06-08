class CandidatePolicy < ApplicationPolicy
  def archetype?
    user == record && !user.archived?
  end
end