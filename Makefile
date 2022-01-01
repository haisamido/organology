
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

build-db: pull-db ## build database image
	@docker tag postgres:$(DBVERSION) $(TAG)-database:$(PROJECT_VERSION)

create-network:
	@docker network create --driver bridge $(PROJECT_NETWORK)

database-up: | build-db ## bring database engine up
	@cd ./docker && \
	DOCKER_BUILDKIT=1 docker-compose up -d $(PROJECT)-database

database-down: ## bring database engine down
	@cd ./docker && \
	DOCKER_BUILDKIT=1 docker-compose down

database-create: database-up ## create project's database
	@psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -tc "SELECT 1 FROM pg_database WHERE datname = '$(DB)'" \
		| grep -q 1 || psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -c "CREATE DATABASE $(DB);"

database-delete: database-up ## delete project's database (NON-RECOVERABLE)
	psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -c "DROP DATABASE IF EXISTS $(DB);"

database-configure: | database-delete database-create ## configure project's database
	psql -h $(DBHOST) -U $(DBUSER) -p $(DBPORT) -d $(DB) < ./db/create_db.sql

build-app:
	cd ./docker && docker build . && docker tag $(IMAGE) $(TAG)

run-app: build-app
	cd ./docker && docker-compose up $(TAG)
