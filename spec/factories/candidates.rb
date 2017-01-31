FactoryGirl.define do
	factory :candidate do
		first_name 'test'
		last_name 'candidate'
		sequence(:email) {|i| "test#{i}@example.com"}
		password 'password'
	end
end
