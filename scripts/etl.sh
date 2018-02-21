#!/bin/sh

CLIENT_ID=0
DBNAME=a_db
VULN_DATA_DBNAME=a_vuln_db

extract_data() {
  sed -i.bak "s/^SET @client_id=.*/SET @client_id=$CLIENT_ID;/g" resources/sql/extract_$table.sql
  rm -f resources/sql/extract_$table.sql.bak
  mysql --defaults-file=./config/.stinger.my.cnf \
        --database=$DBNAME \
        --port=3306 --batch \
        < resources/sql/extract_$table.sql \
        | sed -e 's/NULL/\\N/g' > resources/extracts/$table.csv
}

load_data() {
  mysqlimport --defaults-file=./config/.stinger.my.cnf \
              --ignore-lines=1 \
              --fields-terminated-by='\t' \
              --local \
              $VULN_DATA_DBNAME \
              resources/extracts/$table.csv
  gzip resources/extracts/$table.csv
}

transfer_records() {
  table=$table extract_data
  table=$table load_data
}

run_etl() {
  echo "STARTED - the ETL"
  rm -f logs/*.log
  rm -f resources/extracts/*
  table=assets transfer_records > logs/transfer-records-assets.log
  table=vulnerabilities transfer_records > logs/transfer-records-vulnerabilities.log
  echo "FINISHED - the ETL"
}

# Allows to call a function based on arguments passed to the script
$*
