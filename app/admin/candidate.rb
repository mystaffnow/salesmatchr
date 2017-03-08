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
        # column :sales_type_id |exp|
        #   exp.sales_type.present? ? exp.sales_type.name : ''
        # end
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
end
