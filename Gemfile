source 'https://rubygems.org'

ruby '2.2.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'bootstrap-sass'

# Blog WYSIWYG editor
gem 'bootstrap-wysihtml5-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # manage env variables
	gem 'figaro'
	# debugger
  gem 'pry-rails'
	gem 'pry-byebug'

	# testing packages
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'database_cleaner'

  # static code, security, vulnerability analyser
  gem 'brakeman', :require => false
  
  # static code analyzer
  gem 'rubocop', require: false
  
  # Ruby code quality reporter
  gem "rubycritic", :require => false

  # a code metric tool
  gem "rails_best_practices"

  # A Rake task gem that helps you find the unused routes and controller actions
  gem 'traceroute'

  gem 'execjs'
  gem 'therubyracer'
end

gem 'rmagick', '~> 2.16.0'
gem 'geocoder'
gem 'devise', '~> 3.4.1'
gem 'pg', '~> 0.17.1'
gem 'haml', '~> 4.0.5'
gem 'haml-rails', '~> 0.9.0'
gem 'mixpanel-ruby', '~> 2.2.0'
gem 'rolify', '~> 3.5.2'
gem 'omniauth', '~> 1.2.2'
gem "omniauth-linkedin-oauth2"
gem "paperclip", "~> 4.2"
gem 'aws-sdk', '< 2.0'
gem 'stripe'
gem 'activeadmin', github: 'activeadmin'
gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations'

# Mail send by sendgrid
gem 'sendgrid'
gem 'sendgrid-rails', '~> 3.1.0'
# need to use bootstrap glyphicons
gem 'bootstrap-glyphicons'
# Authorization management
gem 'pundit'

# Create job and run it on backend
gem 'activejob'
# Asnchronous process library
gem 'sucker_punch'

# logging aggregation and static assets serving in production
gem 'rails_12factor', group: :production

# paginator solution
gem 'kaminari'
# freeze time
gem 'timecop'