# dbt_ad_reporting v0.7.0
## 🚨 Breaking Changes 🚨
- The Google Ads dependency has been updated to now reference the latest version of the `dbt_google_ads` package (v0.6.0). This version of the package incorporates new and modified tables within the `Google Ads API` version of the connector. For more information, refer to the relevant [dbt_google_ads](https://github.com/fivetran/dbt_google_ads_source/releases/tag/v0.6.0) and [dbt_google_ads_source](https://github.com/fivetran/dbt_google_ads/releases/tag/v0.6.0) v0.6.0 release notes.

# dbt_ad_reporting v0.6.0
TikTok Ads has been added as a dependency and is enabled by default. Be sure to disable the models via the README if you do not have a TikTok Ads connector.

## Feature Additions
- Added the TikTok Ads package to be included in the final `ad_reporting` model. ([#36](https://github.com/fivetran/dbt_ad_reporting/pull/36))

# dbt_ad_reporting v0.6.0-b1
🎉 dbt v1.0.0 Compatibility Pre Release 🎉 An official dbt v1.0.0 compatible version of the package will be released once existing feature/bug PRs are merged.

## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependencies to refer to the latest individual ad package versions. Additionally, the latest individual ad package versions have a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.
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
