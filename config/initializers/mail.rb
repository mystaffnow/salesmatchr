ActionMailer::Base.register_interceptor(SendGrid::MailInterceptor)

if Rails.env.production? || Rails.env.development?
	ActionMailer::Base.smtp_settings = {
	     :user_name => ENV["NT_SEND_GRID_USER_NAME"],
	     :password => ENV["NT_SEND_GRID_PASSWORD"],
	     :domain => 'http://www.salesmatchr.com/',
	     :address => 'smtp.sendgrid.net',
	     :port => 587,
	     :authentication => :plain,
	     :enable_starttls_auto => true
	 }
end
