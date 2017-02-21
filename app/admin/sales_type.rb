ActiveAdmin.register SalesType do

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

	menu priority: 6, parent: 'Setting'

	permit_params :id, :name

	filter :name

	index do
		selectable_column
		column :id
		column :name
		actions
	end

	show do
		attributes_table do
			row :id
			row :name
		end
	end
end
