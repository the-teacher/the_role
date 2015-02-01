<h2 align="center" class='center' style="text-align:center">
  TheRole 3.0
</h2>

<p align="center" class='center' style="text-align:center">
  <b>Authorization gem for Ruby on Rails</b><br>
  <i>with <a href="https://github.com/TheRole/TheRoleManagementPanelBootstrap3">Management Panel</a></i>
</p>

<p align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/the_role.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

<p align="center" class='center' style="text-align:center">
  <b>Semantic. Flexible. Lightweigh</b>
</p>

<div align="center" class='center' style="text-align:center">

<a href="http://badge.fury.io/rb/the_role"><img src="https://badge.fury.io/rb/the_role.svg" alt="Gem Version" height="18"></a>
&nbsp;
<a href="https://travis-ci.org/TheRole/DummyApp"><img src="https://travis-ci.org/TheRole/DummyApp.svg?branch=master" alt="Build Status" height="18"></a>
&nbsp;
<a href="https://codeclimate.com/github/TheRole/TheRoleApi"><img src="https://codeclimate.com/github/TheRole/TheRoleApi/badges/gpa.svg" /></a>
&nbsp;
<a href="https://www.ruby-toolbox.com/categories/rails_authorization">ruby-toolbox</a>
</div>

### INTRO

TheRole is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in with **2-level-hash**, and **stored in the database as a JSON string**.

<p align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/hash2string.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

Using hashes, makes role system extremely easy to configure and use

* Any Role is a two-level hash, consisting of the <b>sections</b> and nested <b>rules</b>
* A <b>Section</b> may be associated with a <b>controller</b> name
* A <b>Rule</b> may be associated with an <b>action</b> name
* A Section can have many rules
* A Rule can be <b>true</b> or <b>false</b>
* <b>Sections</b> and nested <b>Rules</b> provide an <b>ACL</b> (<b>Access Control List</b>)

#### Management Panel

<table>
<tr>
  <td>
    <b>http://localhost:3000/admin/roles</b>
  </td>
</tr>
<tr>
  <td>
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/gui.png?2" alt="TheRole GUI">
  </td>
</tr>
</table>

#### Import/Export

If you have 2 Rails apps, based on TheRole - you can move roles between them via export/import abilities of TheRole Management Panel.
It can be usefull for Rails apps based on one engine.

<div align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/import_export.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</div>

### Limitations by Design

TheRole uses few conventions over configuration.
It gives simplicity of code, but also some limitations.
You have to know about them before using of TheRole:
<a href="https://github.com/TheRole/docs/blob/master/Limitations.md">Limitations list</a>

## Installation

#### 0. Gemfile

```ruby
# only API
gem 'the_role_api', '~> 3.0.0'
```

or

```ruby
# API and UI
gem 'the_role', '~> 3.0.0'
```

and after that

```sh
bundle
```

#### 1. Change User migration file

Add a `role_id:integer` field to your User Model

```ruby
def self.up
  create_table :users do |t|
    t.string :login
    t.string :email
    t.string :crypted_password
    t.string :salt

    # !!! TheRole field !!!
    t.integer :role_id

    t.timestamps
  end
end
```

#### 2. Install TheRole migration file

```sh
bundle exec rake the_role_engine:install:migrations
```

#### 3. Invoke migrations

```sh
rake db:migrate
```

#### 4. Change User model

```ruby
class User < ActiveRecord::Base
  include TheRole::Api::User

  # ... code ...
end
```

#### 5. Create Role model

```sh
bundle exec rails g the_role install
```

#### 6. Setup TheRole gem

<i>config/initializers/the_role.rb</i>

```ruby
TheRole.configure do |config|
  # [ Devise => :authenticate_user! | Sorcery => :require_login ]
  config.login_required_method = :authenticate_user!

  # layout for Management panel
  config.layout = :the_role_management_panel

  # config.default_user_role          = nil
  # config.first_user_should_be_admin = false

  # config.access_denied_method       = :access_denied
  # config.destroy_strategy           = :restrict_with_exception # can be nil
end
```

#### 7. Create admin role

```sh
rake db:the_role:admin
```

Now you can make any user an Admin via `rails console`, for instance:

```ruby
User.first.update( role: Role.with_name(:admin) )
User.first.admin? # => true
```

<hr>

<p align="center" class='center' style="text-align:center">
  <b>
    You are in deal!<br>
    Thanks for using TheRole!
  </b>
</p>

<hr>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleAPI.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/install.png?2" alt="TheRole. Installation">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleAPI.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/api.png" alt="TheRole API">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/IntegrationWithRailsControllers.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_ctrl.png" alt="Integration with Rails controllers">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/IntegrationWithRailsViews.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_views.png" alt="Integration with Rails views">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/UsingWithStrongParameters.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_params.png" alt="Using with Strong Parameters">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleAPI.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/install_gui.png" alt="TheRole GUI. Installation">
  </a>
</div>

<hr>

### MIT License

Copyright (c) 2012-2015 [Ilya N.Zykin](https://github.com/the-teacher)

[MIT License](https://github.com/TheRole/docs/blob/master/LICENSE.md)

#### Maintainers

[@the-teacher](https://github.com/the-teacher),
[@sedx](https://github.com/sedx),
[@seuros](https://github.com/seuros)

#### Contributors

@igmarin, @doabit, @linjunpop, @egb3
