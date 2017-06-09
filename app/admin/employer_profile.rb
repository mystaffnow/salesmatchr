ActiveAdmin.register EmployerProfile do

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
  actions :all, :except => [:new, :create]

  permit_params :employer_id, :website, :ziggeo_token, :zip, :city,
                :state_id, :description, :avatar

  menu priority: 2, parent: 'Employer'

  controller do
    def scoped_collection
      super.includes([:employer, :state])
    end
  end

  index do
    id_column

    column :employer
    column :website
    column :ziggeo_token
    column :zip
    column :city
    column :state
    column :description
    column :avatar do |img|
      image_tag img.avatar.url(:medium)
    end
    actions
  end

  show do
    attributes_table do
      row :employer_id
      row :website
      row :ziggeo_token
      row :zip
      row :city
      row :avatar do |img|
        image_tag img.avatar.url(:medium)
      end
      row :state_id
      row :description
    end
  end


  form do |f|
    f.inputs 'Fill out the form' do
      f.input :website
      f.input :state_id, as: :select, collection: State.all.map { |x| [x.name, x.id] }, include_blank: false
      f.input :zip
      f.input :city
      f.input :description
      f.input :avatar, as: :file
      f.actions
    end
  end
end
