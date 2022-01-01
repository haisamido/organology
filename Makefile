
ENVIRO = test

PROJECT         = organology
PROJECT_VERSION = latest

DB      = $(PROJECT)
TAG     = $(PROJECT)

IMAGE   = node:alpine

DBVERSION = 13

pull-db:
	docker pull postgres:$(DBVERSION) 

build-db: pull-db ## build postgres database
	docker tag postgres:$(DBVERSION) $(TAG)-database:$(PROJECT_VERSION)

build-app:
	cd ./docker && docker build . && docker tag $(IMAGE) $(TAG)

run-app: build-app
	cd ./docker && docker-compose up $(TAG)
