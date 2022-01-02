.DEFAULT_GOAL := help

ENVIRO = test

PROJECT         = organology
PROJECT_VERSION = latest
PROJECT_NETWORK = $(PROJECT)-network

DB      = $(PROJECT)
TAG     = $(PROJECT)

IMAGE   = node:alpine

DBENGINE   = postgres
DBVERSION  = 13

export DBHOST     = localhost
export DBUSER     = postgres
export DBPASSWORD = postgres
export PGPASSWORD = $(DBPASSWORD)
export DBPORT     = 5432

pull-db:
	@docker pull postgres:$(DBVERSION) 

database-build: pull-db ## build database image
	@docker tag postgres:$(DBVERSION) $(TAG)-database:$(PROJECT_VERSION)

create-network:
	@docker network create --driver bridge $(PROJECT_NETWORK)

database-up: | database-build ## bring database engine up
	@cd ./docker && \
	DOCKER_BUILDKIT=1 docker-compose up -d $(PROJECT)-database

database-down: ## bring database engine down
	@cd ./docker && \
	DOCKER_BUILDKIT=1 docker-compose down

database-create: database-up ## create project's database
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -tc "SELECT 1 FROM pg_database WHERE datname = '$(DB)'" \
		| grep -q 1 || psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -c "CREATE DATABASE $(DB);"

database-drop: database-up ## delete project's database (NON-RECOVERABLE)
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -c "DROP DATABASE IF EXISTS $(DB) WITH (FORCE);"

database-configure: | database-drop database-create ## configure project's database
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -d $(DB) < ./db/create_db.sql

database-insert-records: database-configure ## insert records into project's database
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -d $(DB) < ./db/insert_records.sql

database-test: database-insert-records ## test inserted database records
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -d $(DB) < ./tests/db/tests.sql > ./tests/db/results/run.txt && \
	diff ./tests/db/results/run.txt ./tests/db/results/expected/run.txt

build-app:
	cd ./docker && docker build . && docker tag $(IMAGE) $(TAG)

run-app: build-app
	cd ./docker && docker-compose up $(TAG)

.PHONY: help

help: ## That's me!
	@printf "\033[37m%-30s\033[0m %s\n" "#----------------------------------------------------------------------------------"
	@printf "\033[37m%-30s\033[0m %s\n" "# Makefile targets                          |"
	@printf "\033[37m%-30s\033[0m %s\n" "#----------------------------------------------------------------------------------"
	@printf "\033[37m%-30s\033[0m %s\n" "#-target-----------------------description-----------------------------------------"
	@grep -E '^[a-zA-Z0-9].+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo $* = $($*)
