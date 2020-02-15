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
