# Corelib

A collection of useful classes for simple and fast web applications.

## Classes

* `Corelib::Database` is a simple wrapper for `PostgreSQL`.
* `Corelib::Cache` is a simple wrapper for `Memcached`.
* `Corelib::Mailer` is a simple wrapper for `Mail`.
* `Corelib::Queue` is a simple wrapper for `Beanstalkd`.
* `Corelib::Model` is a class that models can extend to provide simple schema and properties features.
* `Corelib::Log` is a simple wrapper for `Logger`. Can be activated by including the `Corelib::Loggable` module.

## Commands

In the `docker` folder, a Makefile can be used to execute the following commands:

* `make test` to run the rspec test suite
* `make examples` to run all examples files
* `make lint` to check the code syntax
* `make doc` to generate the code documentation

## Configuration

Environment variables are used to configure services like the database, cache, ... etc.

It is recommanded to use the `dotenv` gem in the application to load a `.env` file, where all the secrets are stored.
A `docker/.env.dist` is provided as an example.
