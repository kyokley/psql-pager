.PHONY: build-pgcli build-psql build publish

build-pgcli:
	docker build -t kyokley/pgcli -f pgcli/Dockerfile .

build-psql:
	docker build -t kyokley/psql -f psql/Dockerfile .

build: build-pgcli build-psql

publish: build
	docker push kyokley/pgcli
	docker push kyokley/psql
