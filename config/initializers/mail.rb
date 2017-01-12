ActionMailer::Base.register_interceptor(SendGrid::MailInterceptor)

ActionMailer::Base.smtp_settings = {
     :user_name => ENV["NT_SEND_GRID_USER_NAME"],
     :password => ENV["NT_SEND_GRID_PASSWORD"],
     :domain => ENV["SITE_URL"] || 'http://www.salesmatchr.com/',
     :address => 'smtp.sendgrid.net',
     :port => 587,
     :authentication => :plain,
     :enable_starttls_auto => true
 }
