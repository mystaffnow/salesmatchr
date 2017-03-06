FactoryGirl.define do
  factory :employer do
    sequence(:email) {|i| "test#{i}@example.com"}
    password 'password'
    first_name 'emp first name'
    last_name 'emp last name'
    company 'Emp company name'
  end

  factory :archetype_employer, class: Employer do
    first_name 'test'
    last_name 'employer'
    sequence(:email) {|i| "employer#{i}@example.com"}
    password 'password'
    company 'Emp company name'
	end
end