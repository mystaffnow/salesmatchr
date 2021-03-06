ActiveAdmin.register YearExperience do

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

	menu priority: 8, parent: 'Setting'

	permit_params :id, :name, :low, :high

	actions :all, :except => [:destroy]

	filter :name

	index do
		selectable_column
		column :id
		column :name
		column :low
		column :high
		actions
	end

	show do
		attributes_table do
			row :id
			row :name
			row :low
			row :high
		end
	end
end
