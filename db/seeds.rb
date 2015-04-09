# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


EducationLevel.create :name => "High School"
EducationLevel.create :name => "Associate"
EducationLevel.create :name => "College BA"
EducationLevel.create :name => "College BS"
EducationLevel.create :name => "Masters"
EducationLevel.create :name => "PHD"

SalesType.create :name => "B2B"
SalesType.create :name => "B2C"
SalesType.create :name => "Information Technology"
SalesType.create :name => "Hardware"
SalesType.create :name => "Sofware"
SalesType.create :name => "Medical"
SalesType.create :name => "Financial"
SalesType.create :name => "Federal Government"
SalesType.create :name => "Retail"

State.create :name => "Alaska"
State.create :name => "Arizona"
State.create :name => "Arkansas"
State.create :name => "California"
State.create :name => "Colorado"
State.create :name => "Connecticut"
State.create :name => "Delaware"
State.create :name => "District Of Columbia"
State.create :name => "Florida"
State.create :name => "Georgia"
State.create :name => "Hawaii"
State.create :name => "Idaho"
State.create :name => "Illinois"
State.create :name => "Indiana"
State.create :name => "Iowa"
State.create :name => "Kansas"
State.create :name => "Kentucky"
State.create :name => "Louisiana"
State.create :name => "Maine"
State.create :name => "Maryland"
State.create :name => "Massachusetts"
State.create :name => "Michigan"
State.create :name => "Minnesota"
State.create :name => "Mississippi"
State.create :name => "Missouri"
State.create :name => "Montana"
State.create :name => "Nebraska"
State.create :name => "Nevada"
State.create :name => "New Hampshire"
State.create :name => "New Jersey"
State.create :name => "New Mexico"
State.create :name => "New York"
State.create :name => "North Carolina"
State.create :name => "North Dakota"
State.create :name => "Ohio"
State.create :name => "Oklahoma"
State.create :name => "Oregon"
State.create :name => "Pennsylvania"
State.create :name => "Rhode Island"
State.create :name => "South Carolina"
State.create :name => "South Dakota"
State.create :name => "Tennessee"
State.create :name => "Texas"
State.create :name => "Utah"
State.create :name => "Vermont"
State.create :name => "Virginia"
State.create :name => "Washington"
State.create :name => "West Virginia"
State.create :name => "Wisconsin"
State.create :name => "Wyoming"

JobFunction.create name: "Outside Sales", low: 31, high: 100
JobFunction.create name: "Inside Sales", low: 31, high: 100
JobFunction.create name: "Business Development (bizdev)", low: -10, high: 70
JobFunction.create name: "Sales Manager", low: -30, high: 70
JobFunction.create name: "Sales Operations", low: -100, high: 10
JobFunction.create name: "Customer Service", low: -100, high: 10
JobFunction.create name: "Account Manager", low: -100, high: -11