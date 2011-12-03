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

Define aliases method for correctly work TheRole's controllers

**login_required** or any other method from your auth system

**access_denied** or any other method for processing access denied situation

``` ruby
class ApplicationController < ActionController::Base
  # You Auth system
  include AuthenticatedSystem

  # define aliases for correctly work of TheRole gem
  alias_method :the_login_required, :login_required
  alias_method :the_role_access_denied, :access_denied
end
```

##  Using with controllers

``` ruby
class ArticlesController < ApplicationController
  # Auth system
  before_filter :login_required, :except=>[:index, :show, :tag]
  # Role system
  before_filter :the_role_require,  :except => [:index, :show, :tag]
  before_filter :the_role_object,   :only => [:edit, :update, :rebuild, :destroy]
  before_filter :the_owner_require, :only => [:edit, :update, :rebuild, :destroy]

  # actions
  
end
```

**the_role_object** try to define instance variable by current controller name and params[:id]
@recipe for RecipesController
@user for UserController

Instance variable required for correctly work of **the_owner_require** method.

If you want to define other finder method, you should define **@the_role_object** for correctly work of **the_owner_require** method.

For example

``` ruby
class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  before_filter :the_role_require, :except => [:new, :create]
  before_filter :find_user, :only => [:edit]
  before_filter :the_owner_require, :only => [:edit]

  def new; end
  def create; end
  def cabinet; end
  def edit; end

  private

  def find_user
    @user = User.where(:login => params[:id]).first
    @the_role_object = @user
  end
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