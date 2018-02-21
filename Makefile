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
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/sql/create_record_counts_view.sql

rebuild-vuln-db: ## Drop and rebuild sharded vuln test database
	@echo "Dropping and rebuilding database $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "DROP DATABASE IF EXISTS $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf -e "CREATE DATABASE $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(VULN_DATA_DBNAME) < resources/vuln_data_schema.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(VULN_DATA_DBNAME) < resources/sql/create_record_counts_view.sql

console: ## Jump into the console and interact wih the services
	APP_ENV=$(APP_ENV) bundle exec ruby tasks/console.rb

dump-table: ## Dumps tables specified in this target
	mysqldump --defaults-file=./config/.stinger.my.cnf $(DBNAME) \
		cves > resources/seed_data/cves.sql

dbconnect: ## Connect to the DB with mysql console
	mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME)

require-client-id:
ifndef CLIENT_ID
	$(error CLIENT_ID is not set)
endif

run-etl: require-client-id ## Run the ETL to pump the data from master -> shard
	@echo "Set up the shell script with global variables"
	@sed -i.bak "s/^CLIENT_ID=.*/CLIENT_ID=$(CLIENT_ID)/" scripts/etl.sh
	@sed -i.bak "s/^VULN_DATA_DBNAME=.*/VULN_DATA_DBNAME=$(VULN_DATA_DBNAME)/" scripts/etl.sh
	@sed -i.bak "s/^DBNAME=.*/DBNAME=$(DBNAME)/" scripts/etl.sh
	@rm -f scripts/etl.sh.bak
	@sh scripts/etl.sh run_etl

sanity-check: ## Compares record counts after ETL
	@echo "Record counts for $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) -e "SELECT * FROM record_counts";
	@echo "Record counts for $(VULN_DATA_DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(VULN_DATA_DBNAME) -e "SELECT * FROM record_counts";

etl-for-client-2: ## To transfer and check CLIENT_ID 2 data
	APP_ENV=development CLIENT_ID=2 make rebuild-vuln-db
	APP_ENV=development CLIENT_ID=2 make run-etl
	APP_ENV=development CLIENT_ID=2 make sanity-check

schema-compare: ## Compares sharded schemas
	APP_ENV=test bundle exec ruby tasks/schema_compare.rb


.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
