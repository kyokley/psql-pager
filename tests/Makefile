setup:
	docker-compose up -d postgres
	sleep 3
	docker-compose exec postgres /bin/bash -c 'psql -U postgres -f /app/setup.sql'

down:
	docker-compose down -v

test-pgcli:
	docker-compose up -d pgcli
