namespace :db do
  namespace :roles do
    # rake db:roles:create_test
    desc 'create roles'
    task :create_test => :environment do
      # ADMIN
      role = {
        :system => {
          :administrator => true
        }
      }
      Role.new(
        :name => :admin,
        :title => 'Administrator',
        :description => 'Role for administrator',
        :the_role => role.to_yaml
      ).save!
      puts 'Administrator'

      # MODERATOR
      role = {
        :moderator => {
          :pages => true
        },
        :markup => {
          :html => true
        }
      }
      Role.new(
        :name => :moderator,
        :title => 'Moderator of pages',
        :description => "Moderator #1",
        :the_role => role.to_yaml
      ).save!
      puts 'Moderator of pages'

      # USER
      role = {
        :users => {
          :cabinet => true,
          :update => true,
          :avatar_upload => true
        },
        :profiles => {
          :edit => true,
          :update => true
        },
        :articles => {
          :new => true,
          :create => true,
          :edit => true,
          :update => true,
          :destroy => true,
          :tags => false
        },
        :pages => {
          :new => true,
          :create => true,
          :edit => true,
          :update => true,
          :destroy => true,
          :tags => true
        },
        :markup => {
          :html => false
        }
      }
      Role.new(
        :name => :user,
        :title => 'User',
        :description => "Role for User",
        :the_role => role.to_yaml
      ).save!
      puts 'User'

      # DEMO
      role = {
        :users => {
          :cabinet => true,
          :update => false,
          :avatar_upload => false
        },
        :profiles => {
          :edit => true,
          :update => false
        },
        :articles => {
          :new => true,
          :show => true,
          :create => false,
          :edit => true,
          :update => false,
          :destroy => false,
          :tags => false
        },
        :pages => {
          :new => true,
          :show => true,
          :create => false,
          :edit => true,
          :update => false,
          :destroy => false,
          :tags => false
        },
        :markup => {
          :html => false
        }
      }
      Role.new(
        :name => :demo,
        :title => 'Demo',
        :description => "Demo user",
        :the_role => role.to_yaml
      ).save!
      puts 'Demo'

      puts 'Roles created'
    end#create
  end#roles
end#db