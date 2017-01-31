FactoryGirl.define do
  factory :employer do
    sequence(:email) {|i| "test#{i}@example.com"}
    password 'password'
  end

  factory :archetype_employer, class: Employer do
		zip 10900
		first_name 'test'
		last_name 'employer'
		sequence(:email) {|i| "employer#{i}@example.com"}
		password 'password'
		city 'New york'
		website 'www.example.com'
	end
end