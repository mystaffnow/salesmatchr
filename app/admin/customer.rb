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

  index do
    id_column

    column :employer_id
    column :stripe_card_token
    column :stripe_customer_id
    column :last4

    actions
  end

  show do
    attributes_table do
      row :id
      row :employer_id
      row :stripe_card_token
      row :stripe_customer_id
      row :last4
    end
  end
end
