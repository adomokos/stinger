DBNAME=stinger_test
VULN_DATA_DBNAME=vuln_data_stinger_3_test

test: build-dbs ## Rebuilds the DB and run the specs
	@time bundle exec rspec spec
	@time bundle exec rubocop
