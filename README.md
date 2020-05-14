# PG::Pglogical

[![Gem Version](https://badge.fury.io/rb/pg-pglogical.svg)](http://badge.fury.io/rb/pg-pglogical)
[![Build Status](https://travis-ci.org/ManageIQ/pg-pglogical.svg)](https://travis-ci.org/ManageIQ/pg-pglogical)
[![Code Climate](https://codeclimate.com/github/ManageIQ/pg-pglogical.svg)](https://codeclimate.com/github/ManageIQ/pg-pglogical)
[![Test Coverage](https://codeclimate.com/github/ManageIQ/pg-pglogical/badges/coverage.svg)](https://codeclimate.com/github/ManageIQ/pg-pglogical/coverage)

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

