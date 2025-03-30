
ENV_PATH=./.env
ifneq ("$(wildcard $(ENV_PATH))","")
	 include $(ENV_PATH)
endif

DOCKER_FILE=docker-compose.yml

cnn=$(CONTAINER_PREFIX)_app # Container name
dbcnn=$(CONTAINER_PREFIX)_db

# SETUP

prepare-env:
	cp -n .env.sample .env || true

i:
	composer install

# DOCKER

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

b:
	docker-compose --file $(DOCKER_FILE) build

bs:
	docker-compose --file $(DOCKER_FILE) build $(sn)

# APP

in:
	docker exec -it $(cnn) bash

# DB

dump_name=dump_$(DB_DATABASE).sql
fix_dump_name=fixed_$(dump_name)

in-db:
	docker exec -it $(dbcnn) bash

dump:
	echo "[client]\nuser=$(DB_USERNAME)\npassword=$(DB_PASSWORD)" > ~/.my.cnf && \
	docker cp ~/.my.cnf $(CONTAINER_PREFIX)_db:/root/.my.cnf && \
	docker exec -i $(CONTAINER_PREFIX)_db mysqldump --defaults-extra-file=/root/.my.cnf --no-tablespaces $(DB_DATABASE) > $(dump_name)
	docker exec -i $(CONTAINER_PREFIX)_db rm -f /root/.my.cnf
	rm -f ~/.my.cnf

old=
new=
rep: # Replace string (old replace new) in dump file
	sed 's~$(old)~$(new)~g' $(dump_name) > $(fix_dump_name)

import:
	echo "[client]\nuser=$(DB_USERNAME)\npassword=$(DB_PASSWORD)" > ~/.my.cnf && \
	docker cp ~/.my.cnf $(CONTAINER_PREFIX)_db:/root/.my.cnf && \
	docker exec -i $(CONTAINER_PREFIX)_db mysql --defaults-extra-file=/root/.my.cnf $(DB_DATABASE) < $(fix_dump_name)
	docker exec -i $(CONTAINER_PREFIX)_db rm -f /root/.my.cnf
	rm -f ~/.my.cnf

