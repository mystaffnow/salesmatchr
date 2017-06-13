class EmployerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def account?
    user == record && !user.archived?
  end

  def update?
    user == record && !user.archived?
  end

  def public?
    user == record && !user.archived?
  end

  def add_payment_method?
    user == record && !user.archived?
  end

  def insert_payment_method?
    user == record && !user.archived?
  end

  def list_payment_method?
    user == record && !user.archived?
  end

  def choose_payment_method?
    user == record && !user.archived?
  end

  def public?
    !record.archived?
  end
end