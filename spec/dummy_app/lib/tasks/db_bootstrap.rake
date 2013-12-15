namespace :db do
  # rake db:bootstrap
  desc "Reset DB"
  task bootstrap: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  # rake db:bootstrap_and_seed
  desc "Reset DB and seed"
  task bootstrap_and_seed: :environment do
    Rake::Task["db:bootstrap"].invoke
    Rake::Task["db:seed"].invoke
  end
end