# gem 'the_role' (under development)

| Bye bye CanCan, I got The Role! | Description |
|:------------- |:-------------|
| ![Bye bye CanCan, I got The Role!](https://github.com/the-teacher/the_role/raw/master/Bye_bye_CanCan_I_got_the_Role.png) | TheRole - Semantic, lightweight role system with an administrative interface.<br><br>Role is a two-level hash, consisting of the **sections** and nested **rules**.<br><br>**Section** may be associated with **controller** name.<br><br>**Rule** may be associated with **action** name.<br><br>Section can have many rules.<br><br>Rule can have **true** or **false** value<br><br>**Sections** and nested **Rules** provide **ACL** (**Access Control List**)<br><br>Role **stored in the database as JSON** string.<br><br>Using of hashes, makes role system extremely easy to configure and use.<br> |

| TheRole management web interface |
|:-------------:|
|![TheRole](https://github.com/the-teacher/the_role/raw/master/pic.png)|

## What does it mean semantic?

Semantic - the science of meaning. Human should fast to understand what is happening in a role system.

Look at hash. If you can understand access rules - this role system is semantically.

``` ruby
role = {
  'pages' => {
    'index' => true,
    'show' => true,
    'new' => false,
    'edit' => false,
    'update' => false,
    'destroy' => false
  },
  'articles' => {
    'index' => true,
    'show' => true
  }
  'twitter' => {
    'button' => true,
    'follow' => false
  }
}
```

### How it  works 


Using of hashes, makes role system extremely easy to configure access rules in the role.

### Virtual sections and rules

Usually, we use real names of controllers as names of sections, and we use names of real actions in controllers as names of section's rules.

Like this:

``` ruby
current_user.has_role?(:pages, :show)
```

But you can also create virtual sections and rules:


``` ruby
current_user.has_role?(:twitter, :button)
current_user.has_role?(:facebook, :like)
```

These sections and the rules are not associated with real controllers and actions.
And you can use them as well as other access rules.

### Install and use

``` ruby
  gem 'the_role'
```

``` ruby
  bundle install
```

Add **role_id:integer** to User Model Migration


``` ruby
rake the_role_engine:install:migrations
  >> Copied migration 20111028145956_create_roles.rb from the_role_engine
```

``` ruby
rails g model role --migration=false
```

``` ruby
rake db:create && rake db:migrate
```

Creating roles for test (**not required**)

``` ruby
rake db:roles:test
  >> Administrator, Moderator of pages, User, Demo
```

Define aliases method for correctly work TheRole's controllers

**authenticate_user!** or any other method from your auth system

**access_denied** or any other method for processing access denied situation

**Example for Devise2**

``` ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  def access_denied
    render :text => 'access_denied: requires an role' and return
  end

  # define aliases for correctly work of TheRole admin panel
  # *authenticate_user!* - method from Devise2
  # *access_denied* - define it before alias_method
  # before_filter :role_object_finder, :only   => [:edit, :update, :rebuild, :destroy]
  alias_method :role_login_required, :authenticate_user!
  alias_method :role_access_denied,  :access_denied

end
```

Using with any controller

``` ruby
class PagesController < ApplicationController
  # Devise2 and TheRole before_filters
  before_filter :role_login_required, :except => [:index, :show]
  before_filter :role_require,        :except => [:index, :show]

  before_filter :find_page,           :only   => [:edit, :update, :destroy]
  before_filter :owner_require,       :only   => [:edit, :update, :destroy]

end
```

### WARNING! IT'S IMPORTANT

When you checking **owner_require** - you should before this to define variable **@object_for_ownership_checking** in finder method.

For example:

``` ruby
class PagesController < ApplicationController
  before_filter :find_page,           :only   => [:edit, :update, :destroy]
  before_filter :owner_require,       :only   => [:edit, :update, :destroy]
  
  private

  def find_page
    @page = Page.find params[:id]
    @object_for_ownership_checking = @page
  end
end
```

### Who is the Administrator?

Administrator - a user who can access any section and the rules of your application.
The administrator is the owner of any objects in your application.
Administrator - a user in the role-hash of which there is a section **system** and rule **administrator**.


``` ruby
admin_role_fragment = {
  :system => {
    :administrator => true
  }
}
```

### Who is the Moderator?

Moderator - a user who can access any actions of sections.
Moderator is the owner of any objects of this class.
Moderator - user which has in a section **moderator** rule with name of real or virtual section (controller).

There is role hash of Moderator of Pages (controller) and Twitter (virtual section)

``` ruby
moderator_role_fragment = {
  :moderator => {
    :pages   => true,
    :blogs   => false,
    :twitter => true
  }
}
```

### User methods

Has a user an access to **action** of **section**?

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

### Role methods

``` ruby
# Find a Role by name
@role.find_by_name(:user)
```

``` ruby
# User Model like methods

@role.has?(:pages, :show)       => true | false
@role.moderator?(:pages)        => true | false
@role.admin?                    => true | false
```

## CRUD API

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