include .env
export

build:
	cp ../Gemfile ./ruby/
	docker-compose build --pull

start: build
	docker-compose up

stop:
	docker-compose stop

clean: stop
	docker-compose rm -f

reset: clean
	docker-compose down --rmi local -v --remove-orphans

lint:
	docker-compose run --rm corelib-ruby /bin/bash -c 'cd /code && rake rubocop'

test:
	docker-compose run --rm corelib-ruby /bin/bash -c 'cd /code && rake spec'

doc:
	docker-compose run --rm corelib-ruby /bin/bash -c 'cd /code && rake yard'

database:
	docker-compose exec corelib-db psql -U $(DB_USER) $(DB_DBNAME)
