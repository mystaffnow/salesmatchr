RSpec.configure do |config|
	config.before(:suite) { DatabaseCleaner.clean_with(:truncation)}
	config.before(:each) { 
		DatabaseCleaner.strategy = :transaction
		DatabaseCleaner.start
	}
	config.append_after(:each) {DatabaseCleaner.clean}
end