namespace :db do
  # rake db:bootstrap
  desc "Reset DB"
  task bootstrap: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end
end