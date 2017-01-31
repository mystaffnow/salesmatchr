# == Schema Information
#
# Table name: sales_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SalesType < ActiveRecord::Base
end
