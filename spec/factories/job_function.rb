FactoryGirl.define do
  factory :job_function do
    name "Outside Sales"
    low 11
    high 100
  end

  factory :outside_sales, class: JobFunction do
		name "Outside Sales"
	  low 11
	  high 100
	end

	factory :inside_sales, class: JobFunction do
		name "Inside Sales"
	  low 11
	  high 100
	end

	factory :business_developement, class: JobFunction do
		name "Business Development (bizdev)"
	  low -10
	  high 70
	end

	factory :sales_manager, class: JobFunction do
		name "Sales Manager"
	  low -30
	  high 70
	end

	factory :sales_operations, class: JobFunction do
		name "Sales Operations"
	  low -100
	  high 10
	end

	factory :customer_service, class: JobFunction do
		name "Customer Service"
	  low -100
	  high 10
	end

	factory :account_manager, class: JobFunction do
		name "Account Manager"
	  low -100
	  high -11
	end
end