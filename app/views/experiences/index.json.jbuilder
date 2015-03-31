json.array!(@experiences) do |experience|
  json.extract! experience, :id, :position, :company, :description, :start_date, :end_date, :is_current, :is_sales, :sales_type_id
  json.url experience_url(experience, format: :json)
end
