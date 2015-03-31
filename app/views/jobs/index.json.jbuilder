json.array!(@jobs) do |job|
  json.extract! job, :id, :employer_id, :salary_low, :salary_high, :zip, :is_remote, :title, :description, :is_active
  json.url job_url(job, format: :json)
end
