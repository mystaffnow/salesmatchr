class Education < ActiveRecord::Base
  belongs_to :education_level
  belongs_to :college
end
