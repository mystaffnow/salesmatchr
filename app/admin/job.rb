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
  actions :all, :except => [:new, :create, :edit, :update]

  filter :title
  filter :city

  controller do
    def scoped_collection
      super.includes([:employer, :state, :job_function])
    end
  end

  index do
    id_column
    column :title
    column :description do |job|
    	raw(truncate(job.description, length: 120, omission: "...", escape: false))
    end
    column :employer
    column :salary_low
    column :salary_high
    column :zip
    column :is_remote
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
    column :is_active
    column :status
    column :action do |j|
    	str = j.expired? ? 'Enable' : 'Expired'
    	link_to str, change_status_staffnow_job_path(j.id), method: :put
    end
    column :activated_at

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
	    row :is_active
	    row :status
	    row :activated_at
	  end

    panel 'Job Payment' do
	    table_for job.payments.includes(:employer) do
		  	column :employer_id do |obj|
          obj.employer.present? ? obj.employer.name : ''
        end
		  	column :amount
		  	column :stripe_charge_id
		  	column :status
		  end
	  end

	  panel 'Job Candidates' do
	  	attributes_table_for job.job_candidates.includes(:candidate) do
	  		row :candidate_id
	  		row :status
	  	end
	  end

	  panel 'Candidate Job Actions' do
	  	attributes_table_for job.candidate_job_actions.includes(:candidate) do
	  		row :candidate_id
	  		row :is_saved
	  	end
	  end
  end

  # export feature
  csv do
  	# job
  	column :id
  	column :employer_id
  	column :salary_low
  	column :salary_high
		column :zip
		column :is_remote
		column :title
		column :description
		column :is_active
		column :state_id
		column :city
		column :archetype_low
		column :archetype_high
		column :job_function_id
		column :latitude
		column :longitude
		column :experience_years
		column :created_at
		column :updated_at

		# payment
    column(:payments) do |j|
      if j.payments.present?
        j.payments.map {|p| [p.id,
                              p.employer_id? ? p.employer_id : nil,
                              p.job_id? ? p.job_id : nil,
                              p.amount? ? p.amount : nil,
                              p.stripe_charge_id? ? p.stripe_charge_id : nil,
                              p.status? ? p.status : nil,
                              p.customer_id? ? p.customer_id : nil
          ]}
      else
        [nil, nil, nil, nil, nil, nil, nil, nil]
      end
    end

		# column(:employer_id) do |j|
		# 	j.employer_id
		# end

		# column(:amount) do |j|
		# 	payment = j.payment
		# 	if payment.present?
		# 		payment.amount? ? payment.amount : nil
		# 	else
		# 		nil
		# 	end
		# end

		# column(:stripe_card_token) do |j|
		# 	payment = j.payment
		# 	if payment.present?
		# 		payment.stripe_card_token? ? payment.stripe_card_token : nil
		# 	else
		# 		nil
		# 	end
		# end

		# column(:stripe_customer_id) do |j|
		# 	payment = j.payment
		# 	if payment.present?
		# 		payment.stripe_customer_id? ? payment.stripe_customer_id : nil
		# 	else
		# 		nil
		# 	end
		# end

		# column(:stripe_charge_id) do |j|
		# 	payment = j.payment
		# 	if payment.present?
		# 		payment.stripe_charge_id? ? payment.stripe_charge_id : nil
		# 	else
		# 		nil
		# 	end
		# end

		# column(:status) do |j|
		# 	payment = j.payment
		# 	if payment.present?
		# 		payment.status
		# 	else
		# 		nil
		# 	end
		# end

		# Job Candidates
		column(:job_candidates) do |j|
			if j.job_candidates.present?
				j.job_candidates.map {|jc| [jc.id,
																	 jc.candidate_id,
																	 jc.status]}
			else
				[nil, nil, nil]
			end
		end

		# Candidate Job Action
		column(:candidate_job_actions) do |j|
			if j.candidate_job_actions.present?
				j.candidate_job_actions.map {|jc| [jc.id,
																	 jc.candidate_id,
																	 jc.is_saved]}
			else
				[nil, nil, nil]
			end
		end
  end
  # export feature

  # make job active/inactive
  # if job is active, visible/invisible, admin can make it inactive
	# if job is inactive, admin can make it active
  member_action :change_status, method: :put do
  	if resource.expired?
  		resource.update(status: Job.statuses['enable'],
  										activated_at: Time.now)
  	else
  		resource.update(status: Job.statuses['expired'])
  	end
  	redirect_to staffnow_jobs_path, notice: 'Status is updated successfully!'
  end
end