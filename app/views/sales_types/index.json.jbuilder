json.array!(@sales_types) do |sales_type|
  json.extract! sales_type, :id, :name
  json.url sales_type_url(sales_type, format: :json)
end
