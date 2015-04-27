OmniAuth.config.full_host = (Rails.env.development? ? "http://localhost:3000" : "http://salesmatchr.com" )
Rails.application.config.middleware.use OmniAuth::Builder do
  ssl_options = {}
  ssl_options[:version] = :TLSv1

  ssl = {}
  ssl[:ssl] =  ssl_options
  provider :linkedin, "78tshtou0dssaz", "1Fq0V4dTUL2ZlzEh", :scope => 'r_fullprofile r_emailaddress',
           :fields => ["id", "email-address", "first-name", "last-name", "picture-url", "public-profile-url",
                       "positions" ],
            client_options: { connection_opts: ssl}

end
