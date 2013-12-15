namespace :assets do
  # rake assets:drop
  desc "Drop assets"
  task drop: :environment do
    Rake::Task["assets:clean"].invoke
    Rake::Task["assets:clobber"].invoke
  end

  # rake assets:build
  desc "Precompile assets"
  task build: :environment do
    Rake::Task["assets:drop"].invoke
    Rake::Task["assets:precompile"].invoke
  end
end