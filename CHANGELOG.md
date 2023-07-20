# dbt_ad_reporting v1.5.0

## 🚨 Breaking Changes 🚨
[PR #98](https://github.com/fivetran/dbt_ad_reporting/pull/98) includes the following changes based on the underlying individual package upgrades:

- Amazon Ads dependency upgraded to v0.2.0. Please see the respective upstream [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads/releases/tag/v0.2.0) and [Amazon Ads Source](https://github.com/fivetran/dbt_amazon_ads_source/releases/tag/v0.2.0) releases for more details.
- Pinterest Ads dependency upgraded to v0.8.0. Please see the respective upstream [Pinterest Ads](https://github.com/fivetran/dbt_pinterest/releases/tag/v0.8.0) and [Pinterest Ads Source](https://github.com/fivetran/dbt_pinterest_source/releases/tag/v0.8.0) releases for more details.

## Bug Fixes
- Adding the correct variable name in `ad_reporting__url_report` for passthrough metrics. ([PR #96](https://github.com/fivetran/dbt_ad_reporting/pull/96))

## Contributors
- [@aleix-cd](https://github.com/aleix-cd) ([PR #96](https://github.com/fivetran/dbt_ad_reporting/pull/96))

# dbt_ad_reporting v1.4.0

## 🎉 Feature Enhancement 🎉
- Added `ad_reporting__<report>_passthrough_metrics` variables to easily add common metrics across all platforms into the `ad_reporting` models! This allows metrics other than the standard `clicks`, `impressions`, and `cost` to be included in the final ad reporting models. See below for a full list of new variables and example metrics to passthrough. ([PR #85](https://github.com/fivetran/dbt_ad_reporting/pull/84))
  - It is important to call out that this is only possible if the relevant upstream Ad platform variables have the same metric to be unioned in the roll up model. Please see the [README](https://github.com/fivetran/dbt_ad_reporting#optional-step-6-additional-configurations) section for details around how to configure the passthrough metrics.
  - Please ensure you exercised due diligence when adding metrics to these models. The metrics added by default (`clicks`, `impressions`, and `cost`) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example metric averages, which may be inaccurately represented at the grain for reports created in this package. You will want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package.
```yml
vars:
  ad_reporting__account_passthrough_metrics:
    - name: conversions
    - name: view_through_conversions
  ad_reporting__campaign_passthrough_metrics: 
    - name: total_shares
    - name: conversions
  ad_reporting__ad_group_passthrough_metrics:
    - name: conversions
    - name: interactions
  ad_reporting__ad_passthrough_metrics: ## For both Ad and URL reports
    - name: conversions
    - name: video_views_captured
  ad_reporting__keyword_passthrough_metrics:
    - name: interactions
  ad_reporting__search_passthrough_metrics:
    - name: conversions
    - name: local_spend_amount
```
- Addition of the `pinterest__using_keywords` (default=`true`) variable that allows users to disable the relevant keyword reports in the downstream Pinterest models if they are not used. ([PR #89](https://github.com/fivetran/dbt_ad_reporting/pull/89))

## Under the Hood:

- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([PR #86](https://github.com/fivetran/dbt_ad_reporting/pull/86))
- Updated the pull request [templates](/.github). ([PR #86](https://github.com/fivetran/dbt_ad_reporting/pull/86))

## Contributors
- [@aleix-cd](https://github.com/aleix-cd) ([PR #85](https://github.com/fivetran/dbt_ad_reporting/pull/84))

# dbt_ad_reporting v1.3.1

## Updates
[PR #79](https://github.com/fivetran/dbt_ad_reporting/pull/79) includes the following updates:
- Updated package dependencies for Linkedin Ads v0.7.0, for more information please refer to Linkedin Ads [PR #28](https://github.com/fivetran/dbt_linkedin/pull/28)
- Updated `README` package dependencies to reflect current package versions

# dbt_ad_reporting v1.3.0

##  🎉 Introducing Reddit Ads Compatibility 🎉 
([PR #83](https://github.com/fivetran/dbt_ad_reporting/pull/83)) includes the following feature additions:
- We have added Reddit Ads as another platform to our Ad Reporting package.
- Your Reddit Ads data can now be rolled into the below models:
  - `ad_reporting__account_report`
  - `ad_reporting__campaign_report`
  - `ad_reporting__ad_group_report`
  - `ad_reporting__ad_report`
  - `ad_reporting__url_report`

> Note: If you are **NOT** using Reddit Ads, add the below variable to your `dbt_project.yml` to disable the Reddit Ads models.

```yml
vars:
  ad_reporting__reddit_ads_enabled: False ## True by default
```

# dbt_ad_reporting v1.2.1

## Updates
- Updating `ad_reporting_metrics.yml` to be up to date with [dbt Metrics documentation](https://docs.getdbt.com/docs/build/metrics#derived-metrics) ([PR #82](https://github.com/fivetran/dbt_ad_reporting/pull/82))

## Bug Fixes
- Enabling additional Snapchat Ads columns in `ad_reporting__url_report` that were previously mapped to null values. ([#81](https://github.com/fivetran/dbt_ad_reporting/pull/81))
  - These columns are: ad_group_id (ad_squad_id), ad_group_name (ad_squad_name), campaign_id and campaign_name.
  
## Under the Hood
- Swapped out `calculation_method: expression` for `calculation_method: derived` for derived metrics 

## Contributors
- [@dumkydewilde](https://github.com/dumkydewilde) ([#81](https://github.com/fivetran/dbt_ad_reporting/pull/81))

# dbt_ad_reporting v1.2.0
## 🚨 Breaking Changes 🚨 and 🎉 Feature Enhancements 🎉 
[PR #75](https://github.com/fivetran/dbt_ad_reporting/pull/75) includes the following new features:
- Amazon Ads has officially been released and added to the Ad Reporting package.
- Your Amazon Ad data can now be rolled into the below models:
  - `ad_reporting__account_report`
  - `ad_reporting__campaign_report`
  - `ad_reporting__ad_group_report`
  - `ad_reporting__ad_report`
  - `ad_reporting__search_report`
  - `ad_reporting__keyword_report`
- Documentation has been updated to include Amazon Ads information.

> Note: If you are **NOT** using Amazon Ads, add the below variable to your `dbt_project.yml` to disable the Amazon Ads models.

```yml
vars:
  ad_reporting__amazon_ads_enabled: False ## True by default
```

# dbt_ad_reporting v1.1.0

## 🚨 Breaking Changes 🚨:
[PR #66](https://github.com/fivetran/dbt_ad_reporting/pull/66) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
- Metric attirbutes have been renamed to be consistent with the latest version of dbt-metrics: `sql` -> `expression` and `type` -> `calculation_method`

## 🎉 Features 🎉
- Added ability for a user to allow records having nulls in url fields to be included in the `ad_reporting__url_report` and the underlying `*url_report` models. This is done by setting the below variable to `False` in your `dbt_project.yml` file. ([#72](https://github.com/fivetran/dbt_ad_reporting/pull/72))

```yml
vars:
  ad_reporting__url_report__using_null_filter: False # Use this variable to include null urls for ALL upstream ad platform packages enabled in your project. Default is True. 
```
- Updated README with this information. ([#72](https://github.com/fivetran/dbt_ad_reporting/pull/72))

## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `ad_reporting__url_report` when null urls are allowed. ([#72](https://github.com/fivetran/dbt_ad_reporting/pull/72))
- Updated this package's `integration_tests/seeds/microsoft_ads_campaign_performance_daily_report_data` in light of [PR #23](https://github.com/fivetran/dbt_microsoft_ads_source/pull/23) on `dbt_microsoft_ads_source`.([#68](https://github.com/fivetran/dbt_ad_reporting/pull/68))

# dbt_ad_reporting v1.0.4
## Feature Enhancement
- The `keyword_id` field (which is a surrogate key generated from the combination of 'account_id', 'line_item_id', 'segment', and 'placement' fields within the Twitter Ads source) has been added to the `ad_reporting__keyword_report` model for the Twitter Ads platform. ([#71](https://github.com/fivetran/dbt_ad_reporting/pull/71))

## Bugfixes
- The `not_null` test on the `ad_reporting__keyword_report` has been adjusted to be tested on the `keyword_id` as opposed to the `keyword_text`. This is needed as there may be times where keyword historical records may be removed and lose reference in an upstream join. As such, the text may be lost and the null test should be applied to the ID instead. ([#71](https://github.com/fivetran/dbt_ad_reporting/pull/71))

## Contributors
- [@clay-walker](https://github.com/clay-walker) for being instrumental in understanding and addressing this issue. ([#63](https://github.com/fivetran/dbt_ad_reporting/issues/63))

# dbt_ad_reporting v1.0.2-v1.0.3

## 🕷️ Bugfixes 🕷️
- Updated `twitter_ads__using_keywords` to have consistent defaults. ([#70](https://github.com/fivetran/dbt_ad_reporting/pull/70))

# dbt_ad_reporting v1.0.1

## 🎉 Feature Enhancements 🎉 
[PR #57](https://github.com/fivetran/dbt_ad_reporting/pull/57) incorporates the following change:
- The package now includes a set of pre-defined [metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics) related to clicks, impressions, and spend (definitions [here](https://github.com/fivetran/dbt_ad_reporting/blob/main/models/ad_reporting_metrics.yml)). 
  - Refer to the [README](https://github.com/fivetran/dbt_ad_reporting#optional-step-8-use-predefined-metrics) for the included metrics and instructions on how to use them.
  - Note: This requires you to manually add a dependency on the [dbt metrics package](https://github.com/dbt-labs/dbt_metrics) to use.

## Fixes
[PR #60](https://github.com/fivetran/dbt_ad_reporting/pull/60) incorporates the following change:
- The LinkedIn Ads schema and database variables were incorrectly documented within the README. The README has been updated to reflect the correct variable names. 
  - `linkedin_schema` has been properly updated to reflect `linkedin_ads_schema`
  - `linkedin_database` has been updated to reflect `linkedin_ads_database`. 

## Contributors
- [@clay-walker](https://github.com/clay-walker) ([#60](https://github.com/fivetran/dbt_ad_reporting/pull/60))

# dbt_ad_reporting v1.0.0
## 🚨 Breaking Changes 🚨
[PR #54](https://github.com/fivetran/dbt_ad_reporting/pull/54) incorporates these breaking changes:
- The previous `ad_reporting` model has been renamed to `ad_reporting__url_report` and will only include records that have non-null url values for more information on specific filters please refer to each platform package's `url_report` model.

## 🎉 Feature Enhancements 🎉 
[PR #54](https://github.com/fivetran/dbt_ad_reporting/pull/54) includes the following new features:
- Apple Search Ads has officially been released and added to Ad Reporting.
- In addition to the `ad_reporting__url_report` model update, we have added **five** new models:
  - `ad_reporting__account_report`
  - `ad_reporting__campaign_report`
  - `ad_reporting__ad_group_report`
  - `ad_reporting__ad_report`
  - `ad_reporting__keyword_search_report`
- This package now leverages `ad_reporting__<platform>_enabled` variables to enable/disable all upstream packages and respective models all in one place.
- New corresponding documentation and updated docs for new models.
- This package leverages several different macros in order to successfully build each model and features a `macros_docs.yml` within the `macros` directory that provides details for each macro.

# dbt_ad_reporting v0.8.0
## 🚨 Breaking Changes 🚨
- The `api_source` variable for the Google Ads package is now defaulted to `google_ads` as opposed to `adwords`. The Adwords API has since been deprecated by Google and is now no longer the standard API for the Google Ads connector. Please ensure you are using a Google Ads API version of the Fivetran connector before upgrading this package. ([#53](https://github.com/fivetran/dbt_ad_reporting/pull/53))
  - Please note, the `adwords` version of this package will be fully removed from the package in August of 2022. This means, models under `models/adwords_connector` will be removed in favor of `models/google_ads_connector` models.

## Updates
- The `ad_reporting` final model is now materialized in a schema `<target_schema>_ad_reporting` by default. This may be overwritten if desired. ([#53](https://github.com/fivetran/dbt_ad_reporting/pull/53))
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
