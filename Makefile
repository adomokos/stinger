APP_ENV ?= test

ifeq ($(APP_ENV),development)
	include development.mk
else
	include test.mk
endif ## Included variable configs

THIS_FILE := $(lastword $(MAKEFILE_LIST))

.DEFAULT_GOAL := help

build-dbs: rebuild-db rebuild-vuln-db ## Builds the DB

rebuild-db: ## Drop and rebuild test database
	@echo "Dropping and rebuilding database $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "DROP DATABASE IF EXISTS $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "CREATE DATABASE $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/schema.sql

rebuild-vuln-db: ## Drop and rebuild sharded vuln test database
	@echo "Dropping and rebuilding database $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "DROP DATABASE IF EXISTS $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "CREATE DATABASE $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(VULN_DATA_DBNAME) < resources/vuln_data_schema.sql

console: ## Jump into the console and interact wih the services
	APP_ENV=$(APP_ENV) bundle exec ruby tasks/console.rb

dump-table: ## Dumps tables specified in this target
	mysqldump --defaults-file=./config/.stinger.my.cnf $(DBNAME) \
		cves > resources/seed_data/cves.sql

dbconnect: ## Connect to the DB with mysql console
	mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME)

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
