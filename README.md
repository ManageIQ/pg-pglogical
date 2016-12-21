# PG::Pglogical

This gem extends the ActiveRecord connection object to include methods which map directly to the SQL stored procedure APIs provided by pglogical.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg-pglogical'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg-pglogical

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec:setup spec` to run the tests. `rake spec:teardown` will remove the databases created for test purposes. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ManageIQ/pg-pglogical.

