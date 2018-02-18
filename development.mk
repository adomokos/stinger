DBNAME=stinger_development
VULN_DATA_DBNAME=vuln_data_stinger_development

seed-db: rebuild-db ## Seed the stinger DB
	@echo "Dropping and rebuilding database $(DBNAME)"
