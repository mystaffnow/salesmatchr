FactoryGirl.define do
  factory :job do
    title "Urgent need Sales Manager"
    description "Select from the pull down menu to the left the"
    state
    employer
    city 'Wichita'
    zip "10900"
    salary_low 45000
    salary_high 280000
    experience_years 10
  end
end
