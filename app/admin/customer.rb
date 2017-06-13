ActiveAdmin.register Customer do

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

  menu priority: 3, parent: 'Employer'

  controller do
    def scoped_collection
      super.includes(:employer)
    end
  end

  index do
    id_column

    column :employer
    column :stripe_card_token
    column :stripe_customer_id
    column :last4
    column :card_holder_name
    column :exp_month
    column :exp_year
    column :is_selected

    actions
  end

  show do
    attributes_table do
      row :id
      row :employer_id
      row :stripe_card_token
      row :stripe_customer_id
      row :last4
      row :card_holder_name
      row :exp_month
      row :exp_year
      row :is_selected
    end
  end
end
