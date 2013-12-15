## TheRole - Authorization Gem for Ruby on Rails with administrative interface.

[![Gem Version](https://badge.fury.io/rb/the_role.png)](http://badge.fury.io/rb/the_role) | [![Build Status](https://travis-ci.org/the-teacher/the_role.png?branch=master)](https://travis-ci.org/the-teacher/the_role) | [![Code Climate](https://codeclimate.com/github/the-teacher/the_role.png)](https://codeclimate.com/github/the-teacher/the_role) | [ruby-toolbox](https://www.ruby-toolbox.com/categories/rails_authorization)

### Semantic, Flexible, Lightweight

### INTRO

<table>
<tr>
<th align="left">Bye bye CanCan, I got The Role!</th>
<th align="left">Description</th>
</tr>
<tr>
<td><img src="https://github.com/the-teacher/the_role/raw/master/Bye_bye_CanCan_I_got_the_Role.png" alt="Bye bye CanCan, I got The Role!"></td>
<td>TheRole is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in with 2-level-hash, and store in database with JSON.<br><br>TheRole - Semantic, lightweight role system with an administrative interface.<br><br>Role is a two-level hash, consisting of the <b>sections</b> and nested <b>rules</b>.<br><br><b>Section</b> may be associated with <b>controller</b> name.<br><br><b>Rule</b> may be associated with <b>action</b> name.<br><br>Section can have many rules.<br><br>Rule can have <b>true</b> or <b>false</b> value<br><br><b>Sections</b> and nested <b>Rules</b> provide <b>ACL</b> (<b>Access Control List</b>)<br><br>Role <b>stored in the database as JSON</b> string.<br><br>Using of hashes, makes role system extremely easy to configure and use.<br></td>
</tr>
</table>  

### GUI

<table>
<tr>
  <td>TheRole management web interface => localhost:3000/admin/roles</td>
</tr>
<tr>
  <td><img src="https://github.com/the-teacher/the_role/raw/master/pic.png" alt="TheRole"></td>
</tr>
</table>

puts following yields into your layout:

```ruby
= yield :role_sidebar
= yield :role_main
```

### Rails 4 version

```
gem 'the_role', '~> 2.3'
```

## If you have any questions

Please before ask anything try to launch and play with **[Dummy App](spec/dummy_app)** in spec folder. Maybe example of integration will be better than any documentation. Thank you!

### Instalation

* [INSTALL](#install)
* [INTEGRATION](#integration)
* [Assets and Bootstrap](#assets-and-bootstrap)
* [Configuration (optional)](#configuration)

### Understanding

* [TheRole instead of CanCan?](#therole-instead-of-cancan)
* [What does it mean semantic?](#what-does-it-mean-semantic)
* [Virtual sections and rules](#virtual-sections-and-rules)
* [Using with Views](#using-with-views)
* [Who is Administrator?](#who-is-administrator)
* [Who is Moderator?](#who-is-moderator)
* [Who is Owner?](#who-is-owner)

### API

* [User](#user)
* [Role](#role)

## Install

```ruby
# You can use any Bootstrap 3 version (CSS, LESS, SCSS)
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'

gem "the_role", "~> 2.0.0"
```

```ruby
bundle
```

install note

```
bundle exec rails g the_role --help
```

### Change User migration

Add **role_id:integer** field to your User Model

```ruby
def self.up
  create_table :users do |t|
    t.string :login
    t.string :email
    t.string :crypted_password
    t.string :salt

    # TheRole field
    t.integer :role_id

    t.timestamps
  end
end
```

### Change User model

```ruby
class User < ActiveRecord::Base
  include TheRole::User
  # or following alias for AR:
  # has_role

  # has_many :pages
end
```

### Create Role model

Generate Role model

```ruby
bundle exec rails g the_role install
```

or you can create Role model manually:

```ruby
class Role < ActiveRecord::Base
  include TheRole::Role
  # or following alias for AR:
  # acts_as_role
end
```

install TheRole migrations

```ruby
rake the_role_engine:install:migrations
```

Invoke migration

```ruby
rake db:migrate
```

### Create Admin

Create admin role

```
bundle exec rails g the_role admin
```

Makes any user as Admin

```
User.first.update( role: Role.with_name(:admin) )
```

## Integration

#### Change your ApplicationController

**include TheRoleController** in your Application controller

```ruby
class ApplicationController < ActionController::Base
  include TheRole::Controller

  protect_from_forgery

  def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
  end
end
```
### Configuration

create the_role config:

```
bundle exec rails g the_role setup
```

**config/initializers/the_role.rb**

```ruby
TheRole.configure do |config|
  config.layout                = :application
  config.default_user_role     = :user
  config.access_denied_method  = :access_denied      # define it in ApplicationController
  config.login_required_method = :authenticate_user! # devise auth method

  # config.first_user_should_be_admin = false
  # config.destroy_strategy           = :restrict_with_exception # can be nil
end
```

#### Using with any controller

```ruby
class PagesController < ApplicationController
  before_action :login_required, except: [:index, :show]
  before_action :role_required,  except: [:index, :show]

  before_action :set_page,       only: [:edit, :update, :destroy]
  before_action :owner_required, only: [:edit, :update, :destroy]

  def edit
     # ONLY OWNER CAN EDIT THIS PAGE
  end

  private

  def set_page
    @page = Page.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    # You should define @owner_check_object before invoking **owner_required** method
    @owner_check_object = @page
  end
end
```

### Assets and Bootstrap

**application.css**

```
//= require bootstrap
```

**application.js**

```
//= require jquery
//= require jquery_ujs

//= require bootstrap
//= require the_role_editinplace
```

## Understanding

#### TheRole instead of CanCan?

TheRole in contrast to CanCan has simple and predefined way to find access state of current role. If you don't want to create your own role scheme with CanCan Abilities - TheRole can be a great solution for your.

You can manage roles with simple UI. TheRole's ACL structure is inspired by Rails controllers, that is why it's so great for Rails application.

#### What does it mean semantic?

Semantic - the science of meaning. Human should be able to understand fast what is happening in a role system.

Look at the next Role hash. If you can understand access rules - this authorization system is semantic.

```ruby
role = {
  'pages' => {
    'index'   => true,
    'show'    => true,
    'new'     => false,
    'edit'    => false,
    'update'  => false,
    'destroy' => false
  },
  'articles' => {
    'index'  => true,
    'show'   => true
  },
  'twitter'  => {
    'button' => true,
    'follow' => false
  }
}
```

#### Virtual sections and rules

Usually, we use real names of controllers and actions for names of sections and rules:

```ruby
@user.has_role?(:pages, :show)
```

But, also, you can use virtual names of sections, and virtual names of section's rules.

```ruby
@user.has_role?(:twitter, :button)
@user.has_role?(:facebook, :like)
```

And you can use them as well as other access rules.

#### Using with Views

```ruby
<% if @user.has_role?(:twitter, :button) %>
  Twitter Button is Here
<% else %>
  Nothing here :(
<% end %>
```

#### Who is Administrator?

Administrator is the user who can access any section and the rules of your application.

Administrator is the owner of any objects in your application.

Administrator is the user, which has virtual section **system** and rule **administrator** in the role-hash.


```ruby
admin_role_fragment = {
  :system => {
    :administrator => true
  }
}
```

#### Who is Moderator?

Moderator is the user, which has access to any actions of some section(s).

Moderator is the owner of any objects of some class.

Moderator is the user, which has a virtual section **moderator**, with **section name** as rule name.

There is Moderator of Pages (controller) and Twitter (virtual section)

```ruby
moderator_role_fragment = {
  :moderator => {
    :pages   => true,
    :blogs   => false,
    :twitter => true
  }
}
```

#### Who is Owner?

Administrator is owner of any object in system.

Moderator of pages is owner of any page.

User is owner of object, when **Object#user_id == User#id**.


# API

## User

```ruby
# User's role
@user.role # => Role obj
```

Is it Administrator?

```ruby
@user.admin?                       => true | false
```

Is it Moderator?

```ruby
@user.moderator?(:pages)           => true | false
@user.moderator?(:blogs)           => true | false
@user.moderator?(:articles)        => true | false
```

Has user got an access to **rule** of **section** (action of controller)?

```ruby
@user.has_role?(:pages,    :show)  => true | false
@user.has_role?(:blogs,    :new)   => true | false
@user.has_role?(:articles, :edit)  => true | false

# return true if one of roles is true
@user.any_role?(pages: :show, posts: :show) => true | false
```

Is user **Owner** of object?

```ruby
@user.owner?(@page)                => true | false
@user.owner?(@blog)                => true | false
@user.owner?(@article)             => true | false
```

## Role

```ruby
# Find a Role by name
@role = Role.with_name(:user)
```

```ruby
@role.has?(:pages, :show)       => true | false
@role.moderator?(:pages)        => true | false
@role.admin?                    => true | false

# return true if one of roles is true
@role.any?(pages: :show, posts: :show) => true | false
```

#### CREATE

```ruby
# Create a section of rules
@role.create_section(:pages)
```

```ruby
# Create rule in section (false value by default)
@role.create_rule(:pages, :index)
```

#### READ

```ruby
@role.to_hash => Hash

# JSON string
@role.to_json => String

# check method
@role.has_section?(:pages) => true | false
```

#### UPDATE

```ruby
# set this rule on
@role.rule_on(:pages, :index)
```

```ruby
# set this rule off
@role.rule_off(:pages, :index)
```

```ruby
# Incoming hash is true-mask-hash
# All the rules of the Role will be reseted to false
# Only rules from true-mask-hash will be set true
new_role_hash = {
  :pages => {
    :index => true,
    :show => true
  }
}

@role.update_role(new_role_hash)
```

#### DELETE

```ruby
# delete a section
@role.delete_section(:pages)

# delete a rule in section
@role.delete_rule(:pages, :show)
```

#### Changelog

* 2.1.0 - User#any_role? & Role#any?
* 2.0.3 - create role fix, cleanup
* 2.0.2 - code cleanup, readme
* 2.0.1 - code cleanup
* 2.0.0 - Rails 4 ready, configurable, tests
* 1.7.0 - mass assignment for User#role_id, doc, locales, changes in test app
* 1.6.9 - assets precompile addon
* 1.6.8 - doc, re dependencies
* 1.6.7 - Es locale (beta 0.2)
* 1.6.6 - Ru locale, localization (beta 0.1)
* 1.6.5 - has_section?, fixes, tests (alpha 0.3)
* 1.6.4 - En locale (alpha 0.2)
* 1.6.3 - notifications
* 1.6.0 - stabile release (alpha 0.1)

### i18n

**Ru, En** (by me)

**Es** by @igmarin

**zh_CN** by @doabit & @linjunpop

**PL** by @egb3

### MIT-LICENSE

##### Copyright (c) 2012 [Ilya N.Zykin]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
