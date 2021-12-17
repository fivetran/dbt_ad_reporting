# dbt_ad_reporting v0.6.1
## Feature Additions
- Added the TikTok Ads package to be included in the final `ad_reporting` model. ([#36](https://github.com/fivetran/dbt_ad_reporting/pull/36))

# dbt_ad_reporting v0.5.1
## Feature Additions
- Added the `account_name` and `account_id` to the `stg_snapchat_ads` model. This will allow for the relevant Snapchat Ads account information to flow downstream into the final `ad_reporting` model. ([#30](https://github.com/fivetran/dbt_ad_reporting/pull/30))

## Under the Hood
- Cast the `account_id` and `external_account_id` as strings within the `stg_google_ads` model.

# Contributors 
- @csoule-shaker ([#30](https://github.com/fivetran/dbt_ad_reporting/pull/30))
- @csoule1622 ([#30](https://github.com/fivetran/dbt_ad_reporting/pull/30))

# dbt_ad_reporting v0.1.0 -> v0.5.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!