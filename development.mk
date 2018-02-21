DBNAME=stinger_development
VULN_DATA_DBNAME=vuln_data_stinger_3_development

seed-db: rebuild-db ## Seed the stinger DB
	@echo "Seeding the DB $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/clients.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/assets.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/vulnerabilities.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/cves.sql

extract-seed-data: ## Extracts the seed data zip file
	cd resources
	unzip -p ENCRYPTION_KEY seed_data.zip
