
ENV_PATH=./.env
ifneq ("$(wildcard $(ENV_PATH))","")
	 include $(ENV_PATH)
endif

DOCKER_FILE=docker-compose.yml
cnn=$(CONTAINER_PREFIX)_app # Container name

prepare-env:
	cp -n .env.sample .env || true

i:
	composer install

setup: mig
	docker exec -it $(cnn) chown -R www-data:www-data /var/www

# Docker _____________
up:
	docker compose --file $(DOCKER_FILE) up -d

ups:
	docker compose --file $(DOCKER_FILE) up $(sn) -d

dw:
	docker compose --file $(DOCKER_FILE) down

dws:
	docker compose --file $(DOCKER_FILE) down $(sn)

rs:
	docker compose --file $(DOCKER_FILE) restart $(sn)

in:
	docker exec -it $(cnn) bash

b:
	docker-compose --file $(DOCKER_FILE) build

bs:
	docker-compose --file $(DOCKER_FILE) build $(sn)
