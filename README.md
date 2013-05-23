## TheRole - Authorization Gem for Ruby on Rails with administrative interface.

[rubygems](http://rubygems.org/gems/the_role) | [ruby-toolbox](https://www.ruby-toolbox.com/categories/rails_authorization) | [![Build Status](https://travis-ci.org/the-teacher/the_role.png?branch=master)](https://travis-ci.org/the-teacher/the_role)

### Semantic, Flexible, Lightweight

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

### Stabile versions

**Rails 4**

Stabile, tested, configurable. I like it ;)

```
gem "the_role", "~> 2.0.0"
```

**Rails 3**

First prototype. Not recommended for use.

```
gem "the_role", "~> 1.7.0"
```

### TheRole instead CanCan?

I think, **CanCan** it's classic solution **for programmers**. It's great for many projects! But...

For endpoint users (moderators, admins) CanCan is useless, because it's hasn't default simple User Interface for role management.

**TheRole** oriented **to people**. TheRole inspired by Rails **MVC** structure. If you need simple, powerful and flexible authorization system - TheRole can be useful for you.

### GUI

<table>
<tr>
  <td>TheRole management web interface => localhost:3000/admin/roles</td>
</tr>
<tr>
  <td><img src="https://github.com/the-teacher/the_role/raw/master/pic.png" alt="TheRole"></td>
</tr>
</table> 

# Install

``` ruby
  gem 'the_role'
```

``` ruby
  bundle
```

### User Model migration

Add **role_id:integer** field to your User Model

```ruby
def self.up
  create_table :users do |t|
    t.string :login,            :null    => false
    t.string :email,            :default => nil
    t.string :crypted_password, :default => nil
    t.string :salt,             :default => nil

    t.integer :role_id,         :default => nil

    t.timestamps
  end
end
```

#### Generate Role Model without migration

``` ruby
rails g model role --migration=false
```

#### Generate Role migration

``` ruby
rake the_role_engine:install:migrations
```

#### Create database and migrate

``` ruby
rake db:create && rake db:migrate
```

#### Create fake roles for test (not required)

``` ruby
rake db:roles:test
```

#### Change your ApplicationController

**include TheRole::Requires** in your Application controller

Define aliases method for correctly work TheRole's controllers

``` ruby
class ApplicationController < ActionController::Base
  include TheRoleController

  protect_from_forgery

  def access_denied
    render :text => 'access_denied: requires an role' and return
  end

  alias_method :login_required,     :YOUR_AUTH_SYSTEM_LOGIN_REQUIRE_METHOD
  alias_method :role_access_denied, :access_denied
end
```

**access_denied** or any other method for processing access denied situation

#### YOUR_AUTH_SYSTEM_LOGIN_REQUIRE_METHOD!

* **authenticate_user!** - method for Devise 2
* **require_login** - method for Sorcery
* **some_method** - from your Auth system

#### Using with any controller

``` ruby
class PagesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :role_required,  :except => [:index, :show]

  before_filter :find_page,      :only   => [:edit, :update, :destroy]
  before_filter :owner_required, :only   => [:edit, :update, :destroy]

  private

  def find_page
    @page = Page.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    # You should to define @owner_check_object before invoke of **owner_required** method
    @owner_check_object = @page
  end
end
```

### Using with Views

```ruby
<% if @user.has_role?(:twitter, :button) %>
  Twitter Button is Here
<% else %>
  Access Denied
<% end %>
```

### Who is Administrator?

Administrator it's a user who can access any section and the rules of your application.

Administrator is the owner of any objects in your application.

Administrator it's a user, which has virtual section **system** and rule **administrator** in the role-hash.


``` ruby
admin_role_fragment = {
  :system => {
    :administrator => true
  }
}
```

### Who is Moderator?

Moderator it's a user, which has access to any actions of some section(s).

Moderator is's owner of any objects of some class.

Moderator it's a user, which has a virtual section **moderator**, with **section name** as rule name.

There is Moderator of Pages (controller) and Twitter (virtual section)

``` ruby
moderator_role_fragment = {
  :moderator => {
    :pages   => true,
    :blogs   => false,
    :twitter => true
  }
}
```

### Who is Owner?

Administrator is owner of any object in system.

Moderator of pages is owner of any page.

User is owner of object, when **Object#user_id == User#id**.

## What does it mean semantic?

Semantic - the science of meaning. Human should fast to understand what is happening in a role system.

Look at next Role hash. If you can understand access rules - this authorization system is semantically.

``` ruby
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

### Virtual sections and rules

Usually, we use real names of controllers and actions for names of sections and rules:

``` ruby
current_user.has_role?(:pages, :show)
```

But, also, you can use virtual names of sections, and virtual names of section's rules.

``` ruby
current_user.has_role?(:twitter, :button)
current_user.has_role?(:facebook, :like)
```

And you can use them as well as other access rules.

# User Model methods

Has a user an access to **rule** of **section** (action of controller)?

``` ruby
current_user.has_role?(:pages,    :show)  => true | false
current_user.has_role?(:blogs,    :new)   => true | false
current_user.has_role?(:articles, :edit)  => true | false
```

Is it Moderator?

``` ruby
current_user.moderator?(:pages)           => true | false
current_user.moderator?(:blogs)           => true | false
current_user.moderator?(:articles)        => true | false
```

Is it Administrator?

``` ruby
current_user.admin?                       => true | false
```

Is it **Owner** of object?

``` ruby
current_user.owner?(@page)                => true | false
current_user.owner?(@blog)                => true | false
current_user.owner?(@article)             => true | false
```

# Base Role methods

``` ruby
# User's role
@role = current_user.role
```

``` ruby
# Find a Role by name
@role = Role.find_by_name(:user)
```

``` ruby
@role.has?(:pages, :show)       => true | false
@role.moderator?(:pages)        => true | false
@role.admin?                    => true | false
```

# CRUD API (for console users)

#### CREATE

``` ruby
# Create a section of rules
@role.create_section(:pages)
```

``` ruby
# Create rule in section (false value by default)
@role.create_rule(:pages, :index)
```

#### READ

``` ruby
@role.to_hash => Hash

# JSON string
@role.to_json => String

# JSON string
@role.to_s => String

# check method
@role.has_section?(:pages) => true | false

# check method
@role.has_rule?(:pages, :index) => true | false
```

#### UPDATE

``` ruby
# Incoming hash is true-mask-hash
# All rules of Role will be reset to false
# Only rules from true-mask-hash will be set on true
new_role_hash = {
  :pages => {
    :index => true,
    :show => true
  }
}

@role.update_role(new_role_hash)
```

``` ruby
# set this rule on true
@role.rule_on(:pages, :index)
```

``` ruby
# set this rule on false
@role.rule_off(:pages, :index)
```

### DELETE

``` ruby
# delete a section
@role.delete_section(:pages)

# delete rule in section
@role.delete_rule(:pages, :show)
```

### Changelog

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
