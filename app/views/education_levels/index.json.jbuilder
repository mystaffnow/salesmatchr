json.array!(@education_levels) do |education_level|
  json.extract! education_level, :id, :name
  json.url education_level_url(education_level, format: :json)
end
