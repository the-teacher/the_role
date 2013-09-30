namespace :db do
  namespace :roles do
    # rake db:roles:admin
    desc 'create Admin Role'
    task :admin => :environment do
      puts `clear`
      puts '~'*40
      puts 'TheRole'
      puts '~'*40

      TheRole.create_admin!

      puts "Now you can makes any user as Admin:"
      puts "> rails c"
      puts "> User.first.update( role: Role.with_name(:admin) )"
      puts '~'*40
    end

    # rake db:roles:test
    desc 'create roles'
    task :test => :environment do
      # ADMIN
      Rake::Task["db:roles:admin"].invoke
      puts 'Administrator'

      # MODERATOR
      role = {
        :users => {
          :edit   => true,
          :show   => true,
          :update => true
        },
        :moderator => {
          :pages => true
        },
        :markup => {
          :html => true
        }
      }

      Role.create!(
        :name => :moderator,
        :title       => 'Moderator of pages',
        :description => "Moderator #1",
        :the_role    => role.to_json
      )

      puts 'Moderator of pages'

      # USER
      role = {
        :users => {
          :edit   => true,
          :show   => true,
          :update => true
        },
        :profiles => {
          :edit   => true,
          :update => true
        },
        :articles  => {
          :new     => true,
          :create  => true,
          :edit    => true,
          :update  => true,
          :destroy => true,
          :tags    => false
        },
        :pages => {
          :new     => true,
          :create  => true,
          :edit    => true,
          :update  => true,
          :destroy => true,
          :tags    => true
        },
        :markup => {
          :html => false
        }
      }

      Role.create!(
        :name        => :user,
        :title       => 'User',
        :description => "Role for User",
        :the_role    => role.to_json
      )

      puts 'User'

      # DEMO
      role = {
        :users => {
          :edit   => true,
          :show   => true,
          :update => true
        },
        :profiles => {
          :edit   => true,
          :update => false
        },
        :articles  => {
          :new     => true,
          :show    => true,
          :create  => false,
          :edit    => true,
          :update  => false,
          :destroy => false,
          :tags    => false
        },
        :pages => {
          :new     => true,
          :show    => true,
          :create  => false,
          :edit    => true,
          :update  => false,
          :destroy => false,
          :tags    => false
        },
        :markup => {
          :html => false
        }
      }

      Role.create!(
        :name        => :demo,
        :title       => 'Demo',
        :description => "Demo user",
        :the_role    => role.to_json
      )

      puts 'Demo'

      puts 'Roles created'
    end
  end
end