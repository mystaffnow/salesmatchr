ActiveAdmin.register CandidateProfile do

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

  permit_params :candidate_id, :city, :state_id, :zip, :education_level_id

  menu priority: 2, parent: 'Candidate'

  controller do
    def scoped_collection
      super.includes([:candidate, :state, :education_level])
    end
  end

  index do
    id_column

    column :candidate
    column :city
    column :state
    column :zip
    column :education_level
    column :avatar do |img|
      image_tag img.avatar.url(:medium)
    end
    column :ziggeo_token
    column :is_incognito
    column :is_active_match_subscription

    actions
  end

  show do
    attributes_table do
      row :candidate_id
      row :city
      row :state_id
      row :zip
      row :education_level_id
      row :avatar do |img|
        image_tag img.avatar.url(:medium)
      end
      row :ziggeo_token
      row :is_incognito
      row :is_active_match_subscription
    end
  end


  form do |f|
    f.inputs 'Fill out the form' do
      f.input :city
      f.input :state_id, as: :select, collection: State.all.map { |x| [x.name, x.id] }, include_blank: false
      f.input :zip
      f.input :education_level_id, as: :select, collection: EducationLevel.all.map { |x| [x.name, x.id] }, include_blank: false
      f.input :is_incognito
      f.input :is_active_match_subscription
      f.input :avatar, as: :file
      f.actions
    end
  end
end
