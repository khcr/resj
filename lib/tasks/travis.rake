namespace :travis do 

	desc "Set up rspec & cucumber for travis"
	task travis: :environment do
		puts "[travis.rake] Rake migration"
		`bin/rake db:migrate RAILS_ENV=test`
	  ["rspec spec", "rake cucumber"].each do |cmd|
	    puts "[travis.rake] Starting to run #{cmd}..."
	    system("DISPLAY=:99.0 bundle exec #{cmd}")
	    raise "#{cmd} failed!" unless $?.exitstatus == 0
	  end
	end

end