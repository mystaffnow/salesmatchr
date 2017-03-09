ActiveAdmin.register Job do

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
  
  filter :title
  filter :city

  index do
    id_column
    column :title
    column :description do |job|
    	raw(job.description)
    end
    column :employer
    column :salary_low
    column :salary_high
    column :zip
    column :is_remote
    column :is_active
    column :state_id do |st|
    	st.state.name if st.state.present?
    end
    column :city
    column :archetype_low
    column :archetype_high
    column :job_function_id do |jf|
    	jf.job_function.name if jf.job_function.present?
    end
    column :latitude
    column :longitude
    column :experience_years
    actions
  end

  show do |job|
    attributes_table do
	    row :title
	    row :description do
	    	raw(job.description)
	    end
	    row :employer
	    row :salary_low
	    row :salary_high
	    row :zip
	    row :is_remote
	    row :is_active
	    row :state_id do
	    	job.state.name if job.state.present?
	    end
	    row :city
	    row :archetype_low
	    row :archetype_high
	    row :job_function_id do
	    	job.job_function.name if job.job_function.present?
	    end
	    row :latitude
	    row :longitude
	    row :experience_years
	  end

    panel 'Job Payment' do
	    attributes_table_for job.payment do
		  	row :employer_id
		  	row :amount
		  	row :stripe_card_token
		  	row :stripe_customer_id
		  	row :stripe_charge_id
		  	row :status
		  end
	  end

	  panel 'Job Candidates' do
	  	attributes_table_for job.job_candidates do
	  		row :candidate_id
	  		row :status
	  	end
	  end

	  panel 'Candidate Job Actions' do
	  	attributes_table_for job.candidate_job_actions do
	  		row :candidate_id
	  		row :is_saved
	  	end
	  end
  end
end
