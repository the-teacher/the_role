## TheRole test App

Test App for TheRole

### Prepare app

```
bin/rake db:drop RAILS_ENV=test &&
bin/rake db:create RAILS_ENV=test &&
bin/rake db:migrate RAILS_ENV=test
```

### Test App

```
bundle exec rspec spec/models/user_spec.rb --format documentation
```