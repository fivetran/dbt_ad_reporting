# dbt_ad_reporting v1.14.0

TODO
- google in search report
- country report with standardization of country names
- region report

# dbt_ad_reporting v1.13.0
[PR #137](https://github.com/fivetran/dbt_ad_reporting/pull/137) includes the following updates:

## Breaking Changes
- The following dependencies have been updated following upstream breaking changes. See the below release notes for more information.
  - `dbt_apple_search_ads` ([v0.5.0](https://github.com/fivetran/dbt_apple_search_ads/releases/tag/v0.5.0))
  - `dbt_microsoft_ads` ([v0.10.0](https://github.com/fivetran/dbt_microsoft_ads/releases/tag/v0.10.0))
- Removed the dependency on [calogica/dbt_date](https://github.com/calogica/dbt-date) as it is no longer actively maintained. To maintain functionality, the `get_base_dates` macro (along with all other dependent macros) used in `metricflow_time_spine` semantic model has been replicated and housed within the `macros/fivetran_date_macros` [folder](https://github.com/fivetran/dbt_ad_reporting/tree/main/macros/fivetran_date_macros). All fivetran_date_macros have been prefixed with `fivetran_` to avoid potential naming conflicts.
  - In order to make the transition more seamless, we have retained the variable name of `dbt_date:time_zone`. Therefore, although we removed the dependency on the dbt-date macros and have renamed them, this variable will still be the same.

## Bug Fixes
- Resolved a CLI Warning caused by the `metricflow_time_spine` model not having a properly documented YAML configuration.

## Under The Hood
- Updated `apple_search_ads` and `microsoft_ads` seed files to keep consistent with changes to seed files in the individual packages.
- The `conversions` field for `apple_search_ads` now sources from `tap_installs`.

# dbt_ad_reporting v1.12.0

## Breaking Changes

### Snapchat Ads
- The `dbt_snapchat_ads` dependency has been updated to `[">=0.8.0", "<0.9.0"]`. These upstream versions introduce breaking changes. For details, refer to the [dbt_snapchat_ads v0.8.0](https://github.com/fivetran/dbt_snapchat_ads/releases/tag/v0.8.0) release notes. ([PR #133](https://github.com/fivetran/dbt_ad_reporting/pull/133))
  - Added ad squad and campaign details to the `snapchat_ads__ad_report` model so they can fill snapchat ad fields `int_ad_reporting__ad_report` model. These details populate the following fields in `ad_reporting__ad_report`: 
    - `ad_squad_id` corresponds to the `ad_group_id` value. 
    - `ad_squad_name` corresponds to the `ad_group_name` value.
    - `campaign_id` and `campaign_name` have the equivalent values.

## Under The Hood
- Updated validation tests in the `integration_tests` folder to check for discrepancies between `conversions` and `conversions_value`. ([PR #133](https://github.com/fivetran/dbt_ad_reporting/pull/133))

## Documentation
- Added Quickstart model counts to README. ([#130](https://github.com/fivetran/dbt_ad_reporting/pull/130))
- Corrected references to connectors and connections in the README. ([#130](https://github.com/fivetran/dbt_ad_reporting/pull/130))
- Updated the [DECISIONLOG](https://github.com/fivetran/dbt_ad_reporting/blob/main/DECISIONLOG.md#timezone-considerations) and [README](https://github.com/fivetran/dbt_ad_reporting/blob/main/README.md#timezone-considerations) to include details about timezone differences across ad platforms. ([#131](https://github.com/fivetran/dbt_ad_reporting/pull/131))

# dbt_ad_reporting v1.11.0

## Breaking Changes

### LinkedIn Ads
- The `dbt_linkedin` dependency has been updated to `[">=0.10.0", "<0.11.0"]`, and the `dbt_linkedin_source` dependency has been updated to `[">=0.10.0", "<0.11.0"]`. These upstream versions introduce breaking changes. For details, refer to the [dbt_linkedin_source v0.10.0](https://github.com/fivetran/dbt_linkedin_source/releases/tag/v0.10.0) and [dbt_linkedin v0.10.0](https://github.com/fivetran/dbt_linkedin/releases/tag/v0.10.0) release notes. ([PR #120](https://github.com/fivetran/dbt_ad_reporting/pull/120))
  - Added the `click_uri_type` field to the following models. This field allows users to differentiate which click uri type (`text_ad` or `spotlight`) was used to populate the `click_uri` field.
    - `stg_linkedin_ads__creative_history`
    - `linkedin_ads__creative_report`
    - `linkedin_ads__url_report`
    - Note: Only `text_ad` and `spotlight` click URI types are supported. To request support for additional types, submit a [Feature Request](https://github.com/fivetran/dbt_linkedin_source/issues/70).
  - The `click_uri` field now populates values using a `COALESCE` of `text_ad_landing_page`, `spotlight_landing_page`, and `click_uri`. For details, refer to the [dbt_linkedin_source v0.10.0](https://github.com/fivetran/dbt_linkedin_source/releases/tag/v0.10.0) release notes. ([PR #120](https://github.com/fivetran/dbt_ad_reporting/pull/120))
    - This change aligns with the [LinkedIn Ads API migration](https://learn.microsoft.com/en-us/linkedin/marketing/community-management/contentapi-migration-guide?view=li-lms-2024-05#adcreativesv2-api-creatives-api) and [Fivetran LinkedIn Ads connector update](https://fivetran.com/docs/connectors/applications/linkedin-ads/changelog#january2024), which moved `click_uri` data to `text_ad_landing_page` or `spotlight_landing_page` based on creative type.

### TikTok Ads
- The `dbt_tiktok_ads` dependency has been updated to `[">=0.7.0", "<0.8.0"]`, and the `dbt_tiktok_source` dependency has been updated to `[">=0.7.0", "<0.8.0"]`. These upstream versions introduce breaking changes. For details, refer to the [dbt_tiktok_ads_source v0.7.0](https://github.com/fivetran/dbt_tiktok_ads_source/releases/tag/v0.7.0) and [dbt_tiktok_ads v0.7.0](https://github.com/fivetran/dbt_tiktok_ads/releases/tag/v0.10.0) release notes. ([PR #127](https://github.com/fivetran/dbt_ad_reporting/pull/127))
- The `age` column in the `ADGROUP_HISTORY` table was renamed to `age_groups` in the [July 2023 TikTok update](https://fivetran.com/docs/connectors/applications/tiktok-ads/changelog#july2023). ([PR #127](https://github.com/fivetran/dbt_ad_reporting/pull/127))
  - Previously, the `stg_tiktok_ads__ad_group_history` model coalesced `age` and `age_groups` to handle legacy data. Due to incompatible data types (string and JSON), this coalesced field has been removed in favor of solely the `age_groups` column.
  - To populate historical data in the `age_groups` column, perform a resync of the `ADGROUP_HISTORY` table. TikTok provides all data regardless of the previous sync state.
  - For more details, see the [Tiktok Ads DECISIONLOG](https://github.com/fivetran/dbt_tiktok_ads_source/blob/main/DECISIONLOG.md).

## Documentation Changes
- Improved README structure by moving the Ad Reporting heading above the README tags and aligning it to the left. ([PR #124](https://github.com/fivetran/dbt_ad_reporting/pull/124))

## Under the Hood
- Added consistency validation tests for the following models to enhance integration testing (used internally by Fivetran maintainers) ([PR #127](https://github.com/fivetran/dbt_ad_reporting/pull/127)):
  - `ad_reporting__ad_report`
  - `ad_reporting__url_report`

## Contributors
- [@conrad-mal](https://github.com/conrad-mal) ([PR #124](https://github.com/fivetran/dbt_ad_reporting/pull/124))

# dbt_ad_reporting v1.10.0
[PR #122](https://github.com/fivetran/dbt_ad_reporting/pull/122) introduces the following **BREAKING CHANGES:**

## Feature Updates: Native Conversion Support
- Added `conversions` and `conversions_value` fields to each Ad Reporting end model.
  - **BREAKING**: In the event that you were already including conversions through [passthrough variables](https://github.com/fivetran/dbt_ad_reporting?tab=readme-ov-file#adding-custom-metrics-to-final-reports) and called your field(s) `conversions` and/or `conversions_value`, your old fields will still be included, but they will be suffixed with a `_c`, while the new default conversion fields will take precedence as `conversions` and `conversions_value`
  - For some platforms, conversions data is sent along with the type of event the metrics are attributed to (ie purchases, leads, sign ups). We have largely chosen to consider **purchases, leads, and custom-defined** events to be conversions. However, you may configure this at each individual platform level for the following packages:

| Platform    | Variable | Default Values | How to Use |
| ------------ | ----------- | -------- | ---------- |
| Facebook Ads    | `facebook_ads__conversion_action_types`    |  `offsite_conversion.fb_pixel_custom` + `offsite_conversion.fb_pixel_lead` + `onsite_conversion.lead_grouped` + `offsite_conversion.fb_pixel_purchase` + `onsite_conversion.purchase` | [Configuring Conversion Action Types](https://github.com/fivetran/dbt_facebook_ads?tab=readme-ov-file#configuring-conversion-action-types) |
| LinkedIn Ad Analytics   | `linkedin_ads__conversion_fields`   | `external_website_conversions` + `one_click_leads` | [Adding in Conversion Fields](https://github.com/fivetran/dbt_linkedin?tab=readme-ov-file#adding-in-conversion-fields-variable) |
| Reddit Ads      | `reddit_ads__conversion_event_types` | `lead` + `purchase` + `custom` | [Configure Conversion Event Types](https://github.com/fivetran/dbt_reddit_ads?tab=readme-ov-file#configure-conversion-event-types) |
| Snapchat Ads    | `snapchat_ads__conversion_fields`    | `conversion_purchases` | [Configuring Conversion Fields](https://github.com/fivetran/dbt_snapchat_ads?tab=readme-ov-file#configuring-conversion-fields) |
| Twitter Ads     | `twitter_ads__conversion_fields` AND `twitter_ads__conversion_sale_amount_fields` | `conversion_purchases_metric` + `conversion_custom_metric` AND `conversion_purchases_sale_amount` + `conversion_custom_sale_amount` | [Customizing Types of Conversions](https://github.com/fivetran/dbt_twitter?tab=readme-ov-file#customizing-types-of-conversions) |

## Under the Hood
- Created data validation tests to be used by package maintainers to verify this and future releases.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)
- [@fivetran-poonamagate](https://github.com/fivetran-poonamagate) ([PR #59](https://github.com/fivetran/dbt_google_ads_source/pull/59))

# dbt_ad_reporting v1.9.0

## Under the Hood
- Addition of an blank line between the quoted line and the comment.

## Under the Hood
- Addition of a section tag within the README so the model descriptions may be accessible within the Fivetran UI for Quickstart. ([PR #113](https://github.com/fivetran/dbt_ad_reporting/pull/113))
- Upticked the `google_ads` and `linkedin_ads` dependencies following major releases in both packages in which conversion metrics have been added. Refer to the individual package release notes for more details ([Google Ads](https://github.com/fivetran/dbt_google_ads/releases/tag/v0.11.0), [Linkedin Ads](https://github.com/fivetran/dbt_linkedin/releases/tag/v0.9.0)). ([PR #115](https://github.com/fivetran/dbt_ad_reporting/pull/115))
  - Note: Default conversions have not been added to `ad_reporting` models _yet_, as we are rolling out conversion support to all upstream Ad packages first.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)
- [@fivetran-poonamagate](https://github.com/fivetran-poonamagate) ([PR #59](https://github.com/fivetran/dbt_google_ads_source/pull/59))

# dbt_ad_reporting v1.8.0

[PR #112](https://github.com/fivetran/dbt_ad_reporting/pull/112) includes the following update:

## Dependency Updates
- Tiny update which upticks the `microsoft_ads` dependency following a recent major release. Refer to the Microsoft Ads v0.8.0 [release notes](https://github.com/fivetran/dbt_microsoft_ads/releases/tag/v0.8.0) for what exact updates have been included.

# dbt_ad_reporting v1.7.1
## Bug Fixes
- Adjust the severity of the `account_id` test in `ad_reporting__account_report` to `warn`. This is required since Snapchat can hard-delete records from the history tables, but not from the reporting tables. This ensures that accurate statistics are being reported and production pipelines aren't failing. ([PR #20](https://github.com/fivetran/dbt_snapchat_ads/pull/20))
  - Documents the above decision in the [DECISIONLOG.md](https://github.com/fivetran/dbt_ad_reporting/blob/main/DECISIONLOG.md).

## Under the Hood
- Updated the pull request [templates](/.github) ([PR #110](https://github.com/fivetran/dbt_ad_reporting/pull/110)).
- Included auto-releaser GitHub Actions workflow to automate future releases ([PR #110](https://github.com/fivetran/dbt_ad_reporting/pull/110)).

## Contributors
- [@bthomson22](https://github.com/bthomson22) ([PR #20](https://github.com/fivetran/dbt_snapchat_ads/pull/20))

# dbt_ad_reporting v1.7.0
[PR #103](https://github.com/fivetran/dbt_ad_reporting/pull/103) includes the following update.

## Breaking changes
- Identifiers for the following packages have been updated for consistency with the source name and compatibility with the union schema feature. See the package's changelog for a full list of changes.
  - [dbt_linkedin](https://github.com/fivetran/dbt_linkedin/blob/main/CHANGELOG.md)
  - [dbt_microsoft_ads](https://github.com/fivetran/dbt_microsoft_ads/blob/main/CHANGELOG.md)
  - [dbt_pinterest](https://github.com/fivetran/dbt_pinterest/blob/main/CHANGELOG.md)
  - [dbt_tiktok_ads](https://github.com/fivetran/dbt_tiktok_ads/blob/main/CHANGELOG.md)

- Linkedin ads updates:
  - Updated materializations of [dbt_linkedin](https://github.com/fivetran/dbt_linkedin/blob/main/CHANGELOG.md) non-`tmp` staging models from views to tables. This is to bring the materializations into alignment with other ad reporting packages and eliminate errors in Redshift.
  - Updated the name of the source created by `dbt_linkedin_source` from `linkedin` to `linkedin_ads`. This was to bring the naming used in this package in alignment with our other ad packages and for compatibility with the union schema feature. If you are using this source, you will need to update the name.
 
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple ad reporting connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_ad_reporting/blob/main/README.md#union-multiple-connectors) for more details.

# dbt_ad_reporting v1.6.1
## Updates
- Renames the semantic model from `ad_reporting__ad_report` --> `ad_report` in order to avoid the dunder(__) keyword. ([PR #105](https://github.com/fivetran/dbt_ad_reporting/pull/105))

## Contributors
- [@Jstein77](https://github.com/Jstein77) ([PR #105](https://github.com/fivetran/dbt_ad_reporting/pull/105))

# dbt_ad_reporting v1.6.0
[PR #100](https://github.com/fivetran/dbt_ad_reporting/pull/100) includes the following updates.

## 🚨 New dbt-core version requirement 🚨
- Updated the metrics spec to reflect the new spec in dbt-core 1.6.0. As a result, the new required dbt version is `[">=1.6.0", "<2.0.0"]`. Be sure to upgrade your dbt-core version when upgrading this package to avoid dbt version compatibility errors.

## Feature Updates
- Added `ad_reporting__ad_report.yml` semantic model which is required to define metrics.
- Included `metricflow_time_spine.sql` which is required by Metricflow. This will be deprecated in future releases. If you have already created a `metricflow_time_spine.sql` model in your project, you will need to disable it for this package by setting the variable `ad_reporting__metricflow_time_spine_enabled` to `false` in your project.

```yml
## root dbt_project.yml
vars:
  ad_reporting__metricflow_time_spine_enabled: false ## true by default
```

## Under the Hood
- Added a new variable `dbt_date:time_zone` which is used by the `dbt_date.get_base_dates` macro within the `metricflow_time_spine` model. This variable is nested under the `ad_reporting` hierarchy in the variables config and should not affect any global declarations if you leverage the `dbt_date` package in your own environment. 
  - The default value of this variable is `America/Los_Angeles`, but you may be able override this in your own root project. For more information on why this variable is needed and the different value options, refer to the [dbt-date package documentation](https://github.com/calogica/dbt-date#variables).

```yml
## root dbt_project.yml
vars:
  "dbt_date:time_zone": "America/Chicago" # Default is "America/Los_Angeles"
```

## Documentation
- Please be aware that due to a bug in dbt-core v1.6.0 the docs were not regenerated as part of this release. You can expect a new release in the future with the regenerated docs that contain these updates.

## Contributors
- [@Jstein77](https://github.com/Jstein77) ([PR #100](https://github.com/fivetran/dbt_ad_reporting/pull/100))

# dbt_ad_reporting v1.5.0

## 🚨 Breaking Changes 🚨
[PR #98](https://github.com/fivetran/dbt_ad_reporting/pull/98) includes the following changes based on the underlying individual package upgrades:

- Amazon Ads dependency upgraded to v0.2.0. Please see the respective upstream [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads/releases/tag/v0.2.0) and [Amazon Ads Source](https://github.com/fivetran/dbt_amazon_ads_source/releases/tag/v0.2.0) releases for more details.
- Pinterest Ads dependency upgraded to v0.8.0. Please see the respective upstream [Pinterest Ads](https://github.com/fivetran/dbt_pinterest/releases/tag/v0.8.0) and [Pinterest Ads Source](https://github.com/fivetran/dbt_pinterest_source/releases/tag/v0.8.0) releases for more details.
- Tiktok Ads dependency upgraded to v0.4.0. Please see the respective upstream [Tiktok Ads](https://github.com/fivetran/dbt_tiktok_ads/releases/tag/v0.4.0) and [Tiktok Ads Source](https://github.com/fivetran/dbt_tiktok_ads_source/releases/tag/v0.4.0)

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
