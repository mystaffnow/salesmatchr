require 'rake'
task :reset => :environment do
  system "psql -c 'SELECT pid, pg_terminate_backend(pid) as terminated FROM pg_stat_activity WHERE pid <> pg_backend_pid();' -d salesmatchr"
  system "psql -U pguser postgres -c 'drop database salesmatchr'"
  system "rake db:create"
  system "rake db:migrate"
  system "rake db:seed"
end
