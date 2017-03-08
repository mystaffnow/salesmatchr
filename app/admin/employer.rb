ActiveAdmin.register Employer do

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

	actions :all, :except => [:new, :create, :edit, :update]

  filter :first_name
  filter :last_name
  filter :company
  filter :email

  index do
  	id_column

  	column :first_name
  	column :last_name
  	column :company
  	column :email
  	actions
  end

  show do |emp|
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :company
      row :email
    end

    panel 'Profile Details' do
      attributes_table_for emp.employer_profile do
        row :id
        row :website
        row :ziggeo_token
        row :state_id
        row :city
        row :zip
        row :description
        row :avatar do |img|
          image_tag img.avatar.url(:medium)
        end
      end 
    end

    panel "Jobs" do
    	table_for emp.jobs do
    		column :id
    		column :title
    		column :description
    		column :state_id do |job|
    			job.state.present? ? job.state.name : ''
    		end
    		column :city
    		column :zip
    		column :latitude
    		column :longitude
    		column :salary_low
    		column :salary_high
    		column :job_function_id do |job|
    			job.job_function.present? ? job.job_function.name : ''
    		end
    		column :archetype_low
    		column :archetype_high
    		column :is_remote
    		column :is_active
    	end
    end
  end
end
