json.array!(@candidate_job_actions) do |candidate_job_action|
  json.extract! candidate_job_action, :id, :candidate_id, :job_id, :is_saved
  json.url candidate_job_action_url(candidate_job_action, format: :json)
end
