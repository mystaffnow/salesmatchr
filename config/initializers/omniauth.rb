Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV["NT_LINKEDIN_KEY"], ENV["NT_LINKEDIN_SECRET"]
end
