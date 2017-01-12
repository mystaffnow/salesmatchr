FactoryGirl.define do
	factory :candidate do
		first_name 'test'
		last_name 'candidate'
		sequence(:email) {|i| "test#{i}@example.com"}
		password 'password'
	end

	factory :job do
		title "Urgent need Sales Manager"
		description "Select from the pull down menu to the left the"
	end

	factory :employer do
		sequence(:email) {|i| "test#{i}@example.com"}
		password 'password'
	end

	factory :state do
		name 'Alaska'
	end

	factory :job_candidate do
		job_id 1
		candidate_id 1
	end
end
