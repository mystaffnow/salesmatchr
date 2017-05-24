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

  permit_params :first_name, :last_name, :company, :email, :password, :password_confirmation

	# actions :all, :except => [:new, :create]

  menu priority: 1, parent: 'Employer'

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

  # form code starts
  form do |f|
    f.inputs 'Fill out the form' do
      f.input :first_name
      f.input :last_name
      f.input :company
      if params[:controller]=="staffnow/employers" && (params[:action]=="new" || params[:action] == "create")
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.submit
    end
  end
  # form code ends

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
          image_tag img.avatar.url(:medium) if img.present?
        end
      end
    end

    panel "Jobs" do
    	table_for emp.jobs.includes([:state, :job_function]) do
    		column :id
    		column :title
    		column :description do |job|
          raw(truncate(job.description, length: 120, omission: "...", escape: false))
        end
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
        column :status
        column :activated_at
    	end
    end

    panel 'customer' do
      table_for emp.customers do
        column :employer_id
        column :stripe_card_token
        column :stripe_customer_id
        column :last4
        column :card_holder_name
        column :exp_month
        column :exp_year
        column :is_selected
      end
    end

    panel 'payments' do
      table_for emp.payments.includes(:job) do |obj|
        column :id
        column :employer_id do
          obj.employer.present? ? obj.employer.name : nil
        end
        column :job_id do |jb|
          jb.job.present? ? jb.job.title : nil
        end
        column :amount
        column :stripe_charge_id
        column :status
        column :customer_id
      end
    end
  end

  csv do |employer|
    column :id
    column :first_name
    column :last_name
    column :company
    column :email

    # profile
    column(:website) {|e| e.employer_profile.website}
    column(:ziggeo_token) {|e| e.employer_profile.ziggeo_token}
    column(:zip) {|e| e.employer_profile.zip}
    column(:city) {|e| e.employer_profile.city}
    column(:state_id) {|e| e.employer_profile.state_id}
    column(:description) {|e| e.employer_profile.description}
    column(:avatar_file_name) {|e| e.employer_profile.avatar_file_name}
    column(:avatar_content_type) {|e| e.employer_profile.avatar_content_type}
    column(:avatar_file_size) {|e| e.employer_profile.avatar_file_size}
    column(:avatar_updated_at) {|e| e.employer_profile.avatar_updated_at}

    # jobs
    column(:jobs) do |e|
      if e.jobs.present?
        e.jobs.map {|j| [j.id,
                         j.title? ? j.title : nil,
                         j.description? ? j.description : nil,
                         j.state_id? ? j.state_id : nil,
                         j.city? ? j.city : nil,
                         j.zip? ? j.zip : nil,
                         j.latitude? ? j.latitude : nil,
                         j.longitude? ? j.longitude : nil,
                         j.salary_low? ? j.salary_low : nil,
                         j.salary_high? ? j.salary_high : nil,
                         j.job_function_id? ? j.job_function_id : nil,
                         j.archetype_low? ? j.archetype_low : nil,
                         j.archetype_high? ? j.archetype_high : nil,
                         j.is_remote? ? j.is_remote : nil,
                         j.is_active? ? j.is_active : nil,
                         j.status? ? j.status : nil,
                         j.activated_at ? j.activated_at : nil
                         ]}
      else
        [nil, nil, nil, nil, nil, nil, nil, nil, nil,
         nil, nil, nil, nil, nil, nil, nil, nil]
      end
    end

    # customer
    column(:customer) do |e|
      cus = e.customer
      if cus.present?
        [cus.id,
         cus.stripe_card_token? ? cus.stripe_card_token : nil,
         cus.stripe_customer_id? ? cus.stripe_customer_id : nil,
         cus.last4? ? cus.last4 : nil
        ]
      else
        [nil, nil, nil, nil]
      end
    end

    # payments
    column(:payments) do |e|
      if e.payments.present?
        e.payments.map {|p| [p.id,
                             p.job_id? ? p.job_id : nil,
                             p.amount? ? p.amount : nil,
                             p.stripe_customer_id? ? p.stripe_customer_id : nil,
                             p.stripe_charge_id? ? p.stripe_charge_id : nil,
                             p.status? ? p.status : nil,
                             p.customer_id? ? p.customer_id : nil
          ]}
      else
        [nil, nil, nil, nil, nil, nil, nil]
      end
    end
  end
end
