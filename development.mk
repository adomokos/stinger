DBNAME=stinger_development
VULN_DATA_DBNAME=vuln_data_stinger_development

seed-db: rebuild-db ## Seed the stinger DB
	@echo "Seeding the DB $(DBNAME)"
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/clients.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/assets.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/vulnerabilities.sql
	@mysql --defaults-file=./config/.stinger.my.cnf $(DBNAME) < resources/seed_data/cves.sql

