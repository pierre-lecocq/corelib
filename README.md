# Corelib

A collection of useful classes for simple and fast web applications.

## Classes

* `Corelib::Database` is a simple wrapper for `PostgreSQL`
* `Corelib::Cache` is a simple wrapper for `Memcached`
* `Corelib::Mailer` is a simple wrapper for `Mail`
* `Corelib::Queue` is a simple wrapper for `Beanstalkd`
* `Corelib::Search` is a simple wrapper for `Elasticsearch`
* `Corelib::Model` is a class that any model can extend to provide simple schema and properties features
* `Corelib::Log` is a simple wrapper for `Logger`. Can be activated by including the `Corelib::Loggable` module

## Modules

* `Corelib::Propertized` provides dynamic properties to an object
* `Corelib::Schematized` provides a database schema capabilities to an object
* `Corelib::Connectable` provides a pool of connections to an object

## Install

To install `Corelib` locally:

1. `git clone https://github.com/pierre-lecocq/corelib`
2. `cd corelib`
3. `rake gem:build && rake gem:install`

A simple test to check if everything is done:

```sh
$ irb
irb(main):001:0> require 'corelib'
=> true
irb(main):002:0> Corelib::VERSION
=> "1.0.0"
irb(main):003:0>
```

## Documentation

A rake task is available to generate the documentation thanks to `yard`. Just run:

```sh
rake yard
```

A `doc` folder is now generated with the whole documentation inside.

## Docker commands

For local development, a docker setup is avaialble. Here is the list of the useful commands to run it:

* `make docker:build` to build the services (database, cache, queue, search). It must be run only once.
* `make docker:start` to start the services (database, cache, queue, search)
* `make docker:test` to run the rspec test suite within a container
* `make docker:lint` to check the code syntax within a container
* `make docker:doc` to generate the documentation from a container

For example, to run the test suite, (after having run `make docker:build` previously) just launch: `make docker:test`

## Configuration

Environment variables are used to configure services like the database, cache, ... etc.

It is recommended to use the `dotenv` gem in the application to load a `.env` file, where all the secrets are stored.
