## TheRole test App

App for development and testing TheRole gem

### How to get?

```
git clone git@github.com:the-teacher/the_role.git

cd the_role/spec/the_role_on_devise/

bundle
```

### Start it!

```
rake db:test_launch

rails s
```

### Test it!

```
rake db:bootstrap RAILS_ENV=test
rspec spec/models/ --format documentation
```

### Production mode

```
rake assets:build   RAILS_ENV=production
rake db:test_launch RAILS_ENV=production

rails s -e production
```