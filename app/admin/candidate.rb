ActiveAdmin.register Candidate do

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
  filter :year_experience
  filter :email

  index do
    id_column
    column :first_name
    column :last_name
    column :year_experience_id do |exp|
      exp.year_experience.name if exp.year_experience
    end
    column :archetype_score
    column :archetype_string
    column :email
    actions
  end

  show do |cd|
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :year_experience_id do
        cd.year_experience.name if cd.year_experience
      end
      row :archetype_score
      row :archetype_string
      row :email
    end

    panel 'Profile Details' do
      attributes_table_for cd.candidate_profile do
        row :city
        row :state_id
        row :zip
        row :eduction_level_id
        row :ziggeo_token
        row :is_incognito
        row :avatar do |img|
          image_tag img.avatar.url(:medium)
        end
      end
    end

    panel 'Work history' do
      table_for cd.experiences do
        column :position
        column :company
        column :description
        column :start_date
        column :end_date
        column :sales_type_id do |st|
          st.sales_type.present? ? st.sales_type.name : ''
        end
      end
    end

    panel 'Education' do
      table_for cd.educations do
        column :college_id do |cd|
          cd.college.present? ? cd.college.name : ''
        end
        column :college_other
        column :education_level_id do |cd|
          cd.education_level.present? ? cd.education_level.name : ''
        end
        column :description
        column :start_date
        column :end_date
      end
    end

    panel 'Candidate Question Answers' do
      table_for cd.candidate_question_answers do
        column :question_id do |qus|
          qus.question.name if qus.question
        end
        column :answer_id do |ans|
          ans.answer.name if ans.answer
        end
      end
    end

    panel 'Job Candidates' do
      table_for cd.job_candidates do
        column :job_id
        column :status
      end
    end

    panel 'Candidate Job Actions' do
      table_for cd.candidate_job_actions do
        column :job_id
        column :is_saved
      end
    end
  end

  csv do |candidate|
    column :id
    column :first_name
    column :last_name
    column :year_experience_id
    column :archetype_score
    column :archetype_string
    column :email

    # profile
    column(:city) {|c| c.candidate_profile.city}
    column(:state_id) {|c| c.candidate_profile.state_id}
    column(:zip) {|c| c.candidate_profile.zip}
    column(:education_level_id) {|c| c.candidate_profile.education_level_id}
    column(:ziggeo_token) {|c| c.candidate_profile.ziggeo_token}
    column(:is_incognito) {|c| c.candidate_profile.is_incognito}

    # experience
    column(:experiences) do |c|
      if c.experiences.present?
        c.experiences.map { |e| [e.id,
                               e.position? ? e.position : nil,
                               e.description? ? e.description : nil,
                               e.start_date? ? e.start_date : nil,
                               e.end_date? ? e.end_date : nil] }
       else
        [nil, nil, nil, nil, nil]
       end
    end

    # education
    column(:educations) do |c|
      if c.educations.present?
        c.educations.map { |e| [e.id,
                                e.college_id? ? e.college_id : nil,
                                e.college_other? ? e.college_other : nil,
                                e.education_level_id? ? e.education_level_id : nil,
                                e.description? ? e.description : nil,
                                e.start_date? ? e.start_date : nil,
                                e.end_date? ? e.end_date : nil] }
      else
        [nil, nil, nil, nil, nil, nil, nil]
      end
    end

    # Candidate Question Answers
    column(:candidate_question_answers) do |c|
      if c.candidate_question_answers.present?
        c.candidate_question_answers.map {|cqs| [cqs.id,
                                                 cqs.question_id? ? cqs.question_id : nil,
                                                 cqs.answer_id? ? cqs.answer_id : nil]}
      else
        [nil, nil, nil]
      end
    end

    # job candidates
    column(:job_candidates) do |c|
      if c.job_candidates.present?
        c.job_candidates.map {|jc| [
          jc.id,
          jc.candidate_id? ? jc.candidate_id : nil,
          jc.job_id? ? jc.job_id : nil,
          jc.status? ? jc.status : nil
          ]}
      else
        [nil, nil, nil, nil]
      end
    end

    # candidate job action
    column(:candidate_job_actions) do |c|
      if c.candidate_job_actions.present?
        c.candidate_job_actions.map {|jc| [
          jc.id,
          jc.candidate_id? ? jc.candidate_id : nil,
          jc.job_id? ? jc.job_id : nil,
          jc.is_saved? ? jc.is_saved : nil
          ]}
      else
        [nil, nil, nil, nil]
      end
    end
  end
end
