
TAG   = msdb
IMAGE = node:alpine

build-app:
	cd ./docker && docker build . && docker tag $(IMAGE) $(TAG)

run-app: build-app
	cd ./docker && docker-compose up $(TAG)
