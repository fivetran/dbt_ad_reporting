#!/bin/bash

set -euo pipefail

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
dbt run --target "$db" --full-refresh --vars '{ad_reporting__facebook_ads_enabled: true, ad_reporting__google_ads_enabled: true, ad_reporting__amazon_ads_enabled: false, ad_reporting__apple_search_ads_enabled: false, ad_reporting__linkedin_ads_enabled: true, ad_reporting__microsoft_ads_enabled: false, ad_reporting__pinterest_ads_enabled: false, ad_reporting__reddit_ads_enabled: false, ad_reporting__snapchat_ads_enabled: false, ad_reporting__tiktok_ads_enabled: false, ad_reporting__twitter_ads_enabled: false}' 
dbt test --target "$db" --vars '{ad_reporting__facebook_ads_enabled: true, ad_reporting__google_ads_enabled: true, ad_reporting__amazon_ads_enabled: false, ad_reporting__apple_search_ads_enabled: false, ad_reporting__linkedin_ads_enabled: true, ad_reporting__microsoft_ads_enabled: false, ad_reporting__pinterest_ads_enabled: false, ad_reporting__reddit_ads_enabled: false, ad_reporting__snapchat_ads_enabled: false, ad_reporting__tiktok_ads_enabled: false, ad_reporting__twitter_ads_enabled: false}'

dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
