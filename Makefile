.PHONY: test

default: format lint test

server:
	iex -S mix phx.server

test:
	mix test --cover

lint:
	mix credo

format:
	mix format

pg:
	docker-compose up -d db

psql:
	docker-compose run --rm db psql -h db -U postgres -d hr_dev
