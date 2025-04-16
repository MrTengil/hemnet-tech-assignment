.PHONY: build up bash

build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

bash:
	docker-compose exec web bash

