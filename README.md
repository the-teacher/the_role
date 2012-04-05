# gem 'the_role'

## Bye bye CanCan, I got The Role!

Semantic, lightweight role system with an administrative interface

![TheSortableTree](https://github.com/the-teacher/the_role/raw/master/pic.png)

## What does it mean semantic?

Semantic - the science of meaning. Human should fast to understand what is happening in a role system.

Look at hash. If you can understand access rules - this role system is semantically.

``` ruby
role = {
  :pages => {
    :index => true,
    :show => true,
    :new => false,
    :edit => false,
    :update => false,
    :destroy => false
  },
  :articles => {
    :index => true,
    :show => true
  }
  :twitter => {
    :button => true,
    :follow => false
  }
}
```

### How it  works 

Role - is a two-level hash, consisting of the sections and rules.

**Section** may be associated with the name of a **controller**.

**Rule** may be associated with the name of **action** in the controller.

Section may contain a set of rules.

**Rule in Section** can be set to **true** and **false**, this provide **ACL** (**Access Control List**)

Role hash **stored in the database as YAML** string.
Using of hashes, makes it extremely easy to configure access rules in the role.

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








