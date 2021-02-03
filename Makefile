.PHONY: init init-migration build run db-migrate test tox

init:  build db-upgrade run
	docker-compose run --rm web flask geoeditor init
	@echo "Init done, containers running"

build:
	docker-compose build

run:
	docker-compose up -d

stop:
	docker-compose stop

clean:
	docker-compose down
	rm -rf .tox
	rm -rf .mypy_cache
	rm -f db/*

db-migrate:
	docker-compose run --rm web flask db migrate

db-upgrade:
	docker-compose run --rm web flask db upgrade

test:
	docker-compose run --rm \
		-v $(PWD)/tests:/code/tests:ro \
		-v $(PWD)/.tox:/code/.tox:rw \
		-v $(PWD)/.mypy_cache:/code/.mypy_cache:rw \
		web tox -e test

tox:
	docker-compose run --rm \
		-v $(PWD)/tests:/code/tests:ro \
		-v $(PWD)/.tox:/code/.tox:rw \
		web tox -e py38

lint:
	docker-compose run --rm \
		-v $(PWD)/.tox:/code/.tox:rw \
		-v $(PWD)/.mypy_cache:/code/.mypy_cache:rw \
		web tox -e lint
