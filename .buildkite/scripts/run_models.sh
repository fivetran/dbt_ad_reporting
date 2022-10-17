#!/bin/bash

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps
dbt seed --target "$db" --full-refresh
dbt run --target "$db" --full-refresh
dbt test --target "$db"
## UPDATE FOR VARS HERE, IF NO VARS, PLEASE REMOVE
dbt run --vars '{apple_search_ads__using_search_terms: True}' --target "$db" --full-refresh
dbt test --target "$db"
### END VARS CHUNK, REMOVE IF NOT USING