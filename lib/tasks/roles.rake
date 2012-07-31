namespace :db do
  namespace :roles do

    # rake db:roles:test
    desc 'create roles'
    task :test => :environment do
      # ADMIN
      role = {
        :system => {
          :administrator => true
        }
      }

      Role.create!(
        :name        => :admin,
        :title       => 'Administrator',
        :description => 'Role for administrator',
        :the_role    => role.to_json
      )

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