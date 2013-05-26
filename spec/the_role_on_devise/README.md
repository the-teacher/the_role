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
bundle exec rspec spec/models/ --format documentation
```

### Start App

```
bin/rake db:drop &&
bin/rake db:create &&
bin/rake db:migrate

bin/rails g the_role admin &&
bin/rake db:seed
```