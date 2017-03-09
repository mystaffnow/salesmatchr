ActiveAdmin.register Payment do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  actions :all, :except => [:new, :create, :edit, :update, :destroy]

  index do
  	id_column

  	column :employer_id do |pay|
  		pay.employer.present? ? pay.employer.name : ''
  	end
  	column :job_id do |pay|
  		pay.job.present? ? pay.job.title : ''
  	end
  	column :amount
  	column :stripe_card_token
  	column :stripe_customer_id
  	column :stripe_charge_id
  	column :status

  	actions
  end
end
