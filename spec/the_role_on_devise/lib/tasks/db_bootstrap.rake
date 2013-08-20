namespace :db do
  # rake db:bootstrap
  desc "Reset DB"
  task bootstrap: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  # rake db:test_launch
  task test_launch: :environment do
    Rake::Task["db:bootstrap"].invoke
    Rake::Task["db:roles:admin"].invoke
    Rake::Task["db:seed"].invoke
  end
end