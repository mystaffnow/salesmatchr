json.array!(@educations) do |education|
  json.extract! education, :id, :school, :degree_id, :description, :start_date, :end_date
  json.url education_url(education, format: :json)
end
