FactoryGirl.define do
  factory :question do
    name 'You would rather work alone than in a group.'
  end

  factory :question_second, class: Question do
    name 'You prefer finding your own solution to using a proven one if your
         solution might be more efficient, even if it requires extra work..'
  end

  factory :question_third, class: Question do
    name 'You would rather be given a goal to work towards than a specific task.'
  end

  factory :question_fourth, class: Question do
    name 'You do not get along easily with others.'
  end

  factory :question_fifth, class: Question do
    name 'You prefer having consistency in most situations as opposed to change.'
  end

  factory :question_sixth, class: Question do
    name 'You are easily distracted.'
  end

  factory :question_seventh, class: Question do
    name 'You have an aggressive personality.'
  end

  factory :question_eighth, class: Question do
    name 'You are willing to compromise and work out conflict.'
  end

  factory :question_ninth, class: Question do
    name 'You prefer a rigid schedule.'
  end

  factory :question_tenth, class: Question do
    name 'You are stubborn and sometimes temperamental.'
  end

  factory :question_eleventh, class: Question do
    name 'You consider yourself a natural leader.'
  end

  factory :question_twelveth, class: Question do
    name 'You are easily bored.'
  end

  factory :question_thirteenth, class: Question do
    name 'You favor numbers to images and abstract ideas.'
  end

  factory :question_fourteenth, class: Question do
    name 'You normally do not like being told what to do.'
  end

  factory :question_fifteenth, class: Question do
    name 'You often find yourself becoming restless.'
  end

  factory :question_sixteenth, class: Question do
    name 'You are an innovative thinker.'
  end

  factory :question_seventeenth, class: Question do
    name 'You generally require little to no guidance after being given a task.'
  end

  factory :question_eighteenth, class: Question do
    name 'You have a competitive spirit, which occasionally causes conflict.'
  end

  factory :question_nineteenth, class: Question do
    name "You like trying to change others' opinions to agree with your own."
  end

  factory :question_twentieth, class: Question do
    name 'You immediately jump for new opportunities, sometimes not thinking them through.'
  end
end