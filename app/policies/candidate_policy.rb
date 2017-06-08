class CandidatePolicy < ApplicationPolicy
  def archetype?
    user == record && !user.archived?
  end

  def account?
    user == record && !user.archived?
  end

  def update?
    user == record && !user.archived?
  end

  def update_archetype?
    user == record && !user.archived?
  end
end