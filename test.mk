DBNAME=stinger_test
VULN_DATA_DBNAME=vuln_data_stinger_test

test: build-dbs ## Rebuilds the DB and run the specs
	@bundle exec rspec spec
