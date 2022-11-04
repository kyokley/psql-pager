.PHONY: build-pgcli build-psql build publish

build-pgcli:
	docker build -t kyokley/pgcli -f pgcli/Dockerfile .

build-psql:
	docker build -t kyokley/psql -f psql/Dockerfile .

build: build-pgcli build-psql

publish: build
	docker push kyokley/pgcli
	docker push kyokley/psql

test-setup:
	docker-compose -f tests/docker-compose.yml up -d postgres
	sleep 1
	docker-compose -f tests/docker-compose.yml exec postgres /bin/bash -c 'psql -U postgres -f /app/setup.sql'

test-down:
	docker-compose -f tests/docker-compose.yml down -v

test-pgcli: build-pgcli
	docker-compose -f tests/docker-compose.yml up -d pgcli
	docker-compose -f tests/docker-compose.yml exec pgcli /bin/sh -c 'echo  "SELECT * FROM accounts;" | pgcli -h postgres -U postgres'

test-psql: build-psql
	docker-compose -f tests/docker-compose.yml up -d psql
	docker-compose -f tests/docker-compose.yml exec psql /bin/sh -c 'echo  "SELECT * FROM accounts;" | psql -h postgres -U postgres'

test: test-setup test-psql test-pgcli test-down
