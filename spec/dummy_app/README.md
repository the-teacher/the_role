## TheRole test App

App for development and testing TheRole gem

### How to get?

```
git clone git@github.com:the-teacher/the_role.git

cd the_role/spec/dummy_app/

bundle
```

### Start it!

```
rake db:bootstrap_and_seed

rails s
```

### Test it!

```
RAILS_ENV=test rake db:bootstrap
RAILS_ENV=test rspec --format documentation

rspec spec/models/ --format documentation
```

### Production mode

```
rake assets:build   RAILS_ENV=production
rake db:test_launch RAILS_ENV=production

rails s -e production
```
