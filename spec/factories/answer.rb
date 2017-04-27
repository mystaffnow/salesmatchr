FactoryGirl.define do
  factory :answer do
    name "Strongly Agree"
    score 5
  end

  factory :agree, class: Answer do
    name "Agree"
    score 5
  end

  factory :neutral, class: Answer do
    name "neutral"
    score 5
  end

  factory :strongly_disagree, class: Answer do
    name "Strongly Disagree"
    score 5
  end

  factory :disagree, class: Answer do
    name "Disagree"
    score 5
  end
end