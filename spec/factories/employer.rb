FactoryGirl.define do
  factory :employer do
    sequence(:email) {|i| "test#{i}@example.com"}
    password 'password'
  end
end