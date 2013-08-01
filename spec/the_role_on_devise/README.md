## TheRole test App

Test App for TheRole

### Start App

```
bin/rake db:bootstrap

rails g the_role admin

rake db:seed

rails s
```

### Test App

```
rake db:bootstrap RAILS_ENV=test
rspec spec/models/ --format documentation
```