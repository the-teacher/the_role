## TheRole

Gem for providing simple, but powerful and flexible role system for ROR3 applications.
Based on Hashes.

* Based on MVC semantik (easy to understand what's happening)
* Realtime dynamically management with simple interface
* Customizable

##  Installation

Gemfile

``` ruby
  gem 'the_role'
```

``` ruby
  bundle install
```

``` ruby
rake the_role_engine:install:migrations
  >> Copied migration 20111028145956_create_roles.rb from the_role_engine

rails g model user role_id:integer
rails g model role --migration=false

rake db:create && rake db:migrate
```

Creating roles for test

``` ruby
rake db:roles:test
  >> Administrator, Moderator of pages, User, Demo
```

Define alias method for **the_login_required** for correctly work of admin's controllers

**login_required** or any other method from your auth system

``` ruby
class ApplicationController < ActionController::Base
  # You Auth system
  include AuthenticatedSystem

  # TheRole login_required method alias
  alias_method :the_login_required, :login_required
end
```

##  Manage roles

``` ruby
rails s
```

**admin_roles_path** => **http://localhost:3000/admin/roles**

##  How it works

``` ruby
rails c

user = User.first
user.role = Role.where(:name => :demo).first
user.save

user.admin?
  => false
user.moderator? :pages
  => false
user.has_role? :pages, :index
  => true 
 

user.role = Role.where(:name => :moderator).first
user.save

user.admin?
  => false
user.moderator? :pages
  => true
user.has_role? :pages, :any_crazy_name
  => true

user.role = Role.where(:name => :admin).first
user.save

user.admin?
  => true
user.moderator? :pages
  => true
user.moderator? :any_crazy_name
  => true
user.has_role? :any_crazy_name, :any_crazy_name
  => true

```

Copyright (c) 2011 [Ilya N. Zykin Github.com/the-teacher], released under the MIT license