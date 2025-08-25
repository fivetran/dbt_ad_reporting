# Ad Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_ad_reporting/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_ad_reporting/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.6.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Standardizes schemas from various ad platform connectors and creates reporting models for clicks, spend and impressions aggregated to the account, campaign, ad group, ad, keyword and search levels.
- Currently supports the following Fivetran ad platform connectors:
    - [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads)
    - [Apple Search Ads](https://github.com/fivetran/dbt_apple_search_ads)
    - [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads)
    - [Google Ads](https://github.com/fivetran/dbt_google_ads)
    - [LinkedIn Ad Analytics](https://github.com/fivetran/dbt_linkedin)
    - [Microsoft Advertising](https://github.com/fivetran/dbt_microsoft_ads)
    - [Pinterest Ads](https://github.com/fivetran/dbt_pinterest)
    - [Reddit Ads](https://github.com/fivetran/dbt_reddit_ads)
    - [Snapchat Ads](https://github.com/fivetran/dbt_snapchat_ads)
    - [TikTok Ads](https://github.com/fivetran/dbt_tiktok_ads)
    - [Twitter Ads](https://github.com/fivetran/dbt_twitter)
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
- Generates a comprehensive data dictionary of your source and modeled Ad Reporting data via the [dbt docs site](https://fivetran.github.io/dbt_ad_reporting/)

<!--section="ad_reporting_transformation_model"-->
Refer to the table below for a detailed view of final tables materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_ad_reporting/#!/overview) for more details about these models.

| **Table**                  | **Description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ad_reporting__account_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__account_report)             | Each record represents daily metrics by account                                            |
| [ad_reporting__campaign_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__campaign_report)     | Each record represents daily metrics by campaign and account. |
| [ad_reporting__ad_group_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__ad_group_report)     | Each record represents daily metrics by ad group, campaign and account.                            |
| [ad_reporting__ad_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__ad_report)    | Each record represents daily metrics by ad, ad group, campaign and account.                            |
| [ad_reporting__keyword_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__keyword_report)   | Each record represents daily metrics by keyword, ad group, campaign and account.                           |
| [ad_reporting__search_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__search_report) | Each record represents daily metrics by search query, ad group, campaign and account.                        |
| [ad_reporting__url_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__url_report) | Each record represents daily metrics by URL (and if applicable, URL UTM parameters), ad group, campaign and account.                        |
| [ad_reporting__monthly_campaign_country_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__monthly_campaign_country_report) | Each record represents monthly metrics by campaign, account, and country the ads were served in. Country names are standardized to ISO-3166 names.                        |
| [ad_reporting__monthly_campaign_region_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__monthly_campaign_region_report) |  Each record represents monthly metrics by campaign, account, and region (i.e. state, province, metropolitan area) the ads were served in.                       |

> The individual platform models may have additional platform-specific metrics and fields better suited for deep-dive analyses at the platform level.

### Materialized Models

Each Quickstart transformation job run materializes the following model counts for each selected connector. The total model count represents all staging, intermediate, and final models, materialized as `view`, `table`, or `incremental`:

| **Connector** | **Model Count** |
| ------------- | --------------- |
| Ad Reporting | 10 |
| [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads) | 30 |
| [Apple Search Ads](https://github.com/fivetran/dbt_apple_search_ads) | 26 |
| [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads) | 34 |
| [Google Ads](https://github.com/fivetran/dbt_google_ads) | 29 |
| [LinkedIn Ad Analytics](https://github.com/fivetran/dbt_linkedin) | 25 |
| [Microsoft Advertising](https://github.com/fivetran/dbt_microsoft_ads) | 33 |
| [Pinterest Ads](https://github.com/fivetran/dbt_pinterest) | 34 |
| [Reddit Ads](https://github.com/fivetran/dbt_reddit_ads) | 34 |
| [Snapchat Ads](https://github.com/fivetran/dbt_snapchat_ads) | 29 |
| [TikTok Ads](https://github.com/fivetran/dbt_tiktok_ads) | 22 |
| [Twitter Ads](https://github.com/fivetran/dbt_twitter) | 32 |

## Timezone Considerations
Timezone differences across ad platforms impact standardization due to pre-aggregated data and non-standard timezones. See the [Decision Log - Timezone Considerations](https://github.com/fivetran/dbt_ad_reporting/blob/main/DECISIONLOG.md#timezone-considerations) for details.
<!--section-end-->

## How do I use the dbt package?
### Step 1: Pre-Requisites
- Have at least one of the below supported Fivetran ad platform connections syncing data into your destination. This package currently supports:
    - [Amazon Ads](https://fivetran.com/docs/applications/amazon-ads)
    - [Apple Search Ads](https://fivetran.com/docs/applications/apple-search-ads)
    - [Facebook Ads](https://fivetran.com/docs/applications/facebook-ads)
    - [Google Ads](https://fivetran.com/docs/applications/google-ads)
    - [LinkedIn Ad Analytics](https://fivetran.com/docs/applications/linkedin-ads)
    - [Microsoft Advertising](https://fivetran.com/docs/applications/microsoft-advertising)
    - [Pinterest Ads](https://fivetran.com/docs/applications/pinterest-ads)
    - [Reddit Ads](https://fivetran.com/docs/applications/reddit-ads)
    - [Snapchat Ads](https://fivetran.com/docs/applications/snapchat-ads)
    - [TikTok Ads](https://fivetran.com/docs/applications/tiktok-ads)
    - [Twitter Ads](https://fivetran.com/docs/applications/twitter-ads)
> While you need only one of the above connectors to utilize this package, we recommend having at least two to gain the rollup benefit of this package.

- This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, **Postgres** and **Databricks**. Ensure you are using one of these supported databases.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` as well as the `calogica/dbt_expectations` then the `google_ads_source` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']

  - macro_namespace: dbt_expectations
    search_order: ['google_ads_source', 'dbt_expectations']
```

### Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/ad_reporting
    version: [">=2.0.0", "<2.1.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the individual ad platform packages in this file. The ad reporting package itself has dependencies on these packages and will install them as well.

### Step 3: Configure Database and Schema Variables
By default, this package looks for your ad platform data in your target database. If this is not where your app platform data is stored, add the relevant `<connector>_database` variables to your `dbt_project.yml` file (see below).
> Please note, cross-database querying, where the `*_database` variable differs from the database specified in your `profiles.yml`, is not supported by all dbt adapters (e.g., dbt-redshift). Refer to the documentation for your specific destination adapter for more details on its capabilities.

```yml
vars:
    amazon_ads_schema: amazon_ads
    amazon_ads_database: your_database_name

    apple_search_ads_schema: apple_search_ads
    apple_search_ads_database: your_database_name

    facebook_ads_schema: facebook_ads
    facebook_ads_database: your_database_name 

    google_ads_schema: google_ads
    google_ads_database: your_database_name 

    microsoft_ads_schema: bingads
    microsoft_ads_database: your_database_name

    linkedin_ads_schema: linkedin_ads 
    linkedin_ads_database: your_database_name  

    pinterest_schema: pinterest
    pinterest_database: your_database_name 

    reddit_ads_schema: reddit_ads
    reddit_ads_database: your_database_name 

    snapchat_schema: snapchat_ads
    snapchat_database: your_database_name 

    tiktok_ads_schema: tiktok_ads
    tiktok_ads_database: your_database_name

    twitter_ads_schema: twitter_ads
    twitter_ads_database: your_database_name  
```

### Step 4: Enabling/Disabling Models
This package takes into consideration that not every account will have every feature enabled per platform. If your syncs exclude certain tables, it is because you either don't use that functionality in your respective ad platforms or have actively excluded some tables from your syncs.

#### Disable Platform Specific Reporting
If you would like to disable all reporting for any specific platform, please include the respective variable(s) in your `dbt_project.yml`. Each is assumed to be `True` by default.

```yml
vars:
  ad_reporting__amazon_ads_enabled: False
  ad_reporting__apple_search_ads_enabled: False
  ad_reporting__facebook_ads_enabled: False
  ad_reporting__google_ads_enabled: False
  ad_reporting__linkedin_ads_enabled: False
  ad_reporting__microsoft_ads_enabled: False
  ad_reporting__pinterest_ads_enabled: False
  ad_reporting__reddit_ads_enabled: False
  ad_reporting__snapchat_ads_enabled: False
  ad_reporting__tiktok_ads_enabled: False
  ad_reporting__twitter_ads_enabled: False
```

#### Enable/Disable Specific Reports within Platforms
For **Apple Search Ads**, if you are not utilizing the search functionality, you may choose to update the respective variable below ([details](https://github.com/fivetran/dbt_apple_search_ads?tab=readme-ov-file#disabling-additional-models)).

For **Facebook Ads**, if you *are* utilizing geo-targeted ads, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_facebook_ads/tree/main?tab=readme-ov-file#enable-or-disable-country-and-region-reports)).

For **Google Ads**, if you are not utilizing the search functionality, you may choose to update the corresponding variable below ([details](https://github.com/fivetran/dbt_google_Ads?tab=readme-ov-file#disable-search-term-keyword-stats)).

For **Linkedin Ads**, if you are not tracking geo-targeted campaign performance, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_linkedin/tree/main?tab=readme-ov-file#disable-country-and-region-reports)).

For **Microsoft Ads**, if you *are* tracking geo-targeted campaign performance, you may choose to update the corresponding variable below ([details](https://github.com/fivetran/dbt_microsoft_ads/tree/main?tab=readme-ov-file#enable-geographic-reports)).

For **Pinterest Ads**, if you are not tracking keyword and/or geo-targeted campaign performance, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_pinterest/tree/main?tab=readme-ov-file#step-4-enabledisable-models-and-sources)).

For **Reddit Ads**, if you are not tracking country-targeted campaign performance, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_reddit_ads/tree/main?tab=readme-ov-file#step-4-enabledisable-models-and-sources)).

For **Snapchat Ads**, if you *are* tracking geo-targeted campaign performance, you may choose to update the corresponding variable below ([details](https://github.com/fivetran/dbt_snapchat_ads/tree/main?tab=readme-ov-file#enabling-models-that-are-disabled-by-default)).

For **TikTok Ads**, if you are not tracking country-targeted campaign performance, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_tiktok_ads/tree/main?tab=readme-ov-file#disable-country-reports)).

For **Twitter Ads**, if you are not tracking keyword performance or *are* tracking geo-targeted campaign performance, you may choose to update the corresponding variables below ([details](https://github.com/fivetran/dbt_twitter/tree/main?tab=readme-ov-file#step-4-disabling-or-enabling-models)).

Add the following variables to your `dbt_project.yml` file

```yml
vars:
  # Apple Search Ads
  apple_search_ads__using_search_terms: False # True by default

  # Facebook Ads
  facebook_ads__using_demographics_country: True # False by default. Enables country-based reporting
  facebook_ads__using_demographics_region: True # False by default. Enables region-based reporting

  # Google Ads
  google_ads__using_search_term_keyword_stats: False # True by default

  # Linkedin Ads
  linkedin_ads__using_geo: False # True by default
  linkedin_ads__using_monthly_ad_analytics_by_member_country: False # True by default
  linkedin_ads__using_monthly_ad_analytics_by_member_region: False # True by default

  # Microsoft Ads
  microsoft_ads__using_geographic_daily_report: True # False by default. Enables coyntry and region-based reporting

  # Pinterest Ads
  pinterest__using_keywords: False # True by default
  pinterest__using_pin_promotion_targeting_report: False # True by default. Disables country and region-based reporting
  pinterest__using_targeting_geo: False # True by default. Disables country-based reporting
  pinterest__using_targeting_geo_region: False # True by default. Disables region-based reporting

  # Reddit Ads
  reddit_ads__using_business_account: false # Default is true. Will use ACCOUNT if set to false.
  reddit_ads__using_campaign_country_report: false # True by default. Disables country-based reporting
  reddit_ads__using_campaign_country_conversions_report: false # True by default. Disables country-based conversions reporting

  # Snapchat Ads
  snapchat_ads__using_campaign_country_report: true # False by default. Enables country-based reporting
  snapchat_ads__using_campaign_region_report: true # False by default. Enables region-based reporting

  # TikTok Ads
  tiktok_ads__using_campaign_country_report: False # True by default. Disables country-based reporting

  # Twitter Ads
  twitter_ads__using_keywords: False # True by default
  twitter_ads__using_campaign_locations_report: True # False by default. Enables country-based reporting
  twitter_ads__using_campaign_regions_report: True # False by default. Enables region-based reporting
```

> Note: Users running the Ad Reporting models via Fivetran Quickstart will have these variables dynamically set based on the presence of relevant source tables.

### (Recommended) Step 5: Change the Build Schema
By default this package will build all models in your `<target_schema>` with the respective package suffixes (see below). This behavior can be tailored to your preference by making use of custom schemas. If you would like to override the current naming conventions, please add the following configuration to your `dbt_project.yml` file and rename `+schema` configs:

```yml
models:  
  ad_reporting:
    +schema: ad_reporting # default schema suffix

  amazon_search_ads:
    +schema: amazon_ads # default schema suffix
    staging:
      +schema: amazon_ads_source # default schema suffix

  apple_search_ads:
    +schema: apple_search_ads # default schema suffix
    staging:
      +schema: apple_search_ads_source # default schema suffix

  facebook_ads:
    +schema: facebook_ads # default schema suffix
    staging:
      +schema: facebook_ads_source # default schema suffix

  google_ads:
    +schema: google_ads # default schema suffix
    staging:
      +schema: google_ads_source # default schema suffix

  linkedin:
    +schema: linkedin_ads # default schema suffix
    staging:
      +schema: linkedin_ads_source # default schema suffix

  microsoft_ads:
    +schema: microsoft_ads # default schema suffix
    staging:
      +schema: microsoft_ads_source # default schema suffix

  pinterest:
    +schema: pinterest # default schema suffix
    staging:
      +schema: pinterest_source # default schema suffix

  reddit_ads:
    +schema: reddit_ads # default schema suffix
    staging:
      +schema: reddit_ads_source # default schema suffix

  snapchat_ads:
    +schema: snapchat_ads # default schema suffix
    staging:
      +schema: snapchat_ads_source # default schema suffix

  tiktok_ads:
    +schema: tiktok_ads # default schema suffix
    staging:
      +schema: stg_tiktok_ads # default schema suffix

  twitter_ads:
    +schema: twitter_ads # default schema suffix
    staging:
      +schema: twitter_ads_source # default schema suffix
```

> Provide a blank `+schema: ` to write to the `target_schema` without any suffix.

### (Optional) Step 6: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple ad reporting connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `<package_name>_union_schemas` OR `<package_name>_union_databases` variables (cannot do both) in your root `dbt_project.yml` file. Below are the variables and examples for each connection:

```yml
vars:
    amazon_ads_union_schemas: ['amazon_ads_usa','amazon_ads_canada']
    amazon_ads_union_databases: ['amazon_ads_usa','amazon_ads_canada']

    apple_search_ads_union_schemas: ['apple_search_ads_usa','apple_search_ads_canada']
    apple_search_ads_union_databases: ['apple_search_ads_usa','apple_search_ads_canada']

    facebook_ads_union_schemas: ['facebook_ads_usa','facebook_ads_canada']
    facebook_ads_union_databases: ['facebook_ads_usa','facebook_ads_canada']

    google_ads_union_schemas: ['google_ads_usa','google_ads_canada']
    google_ads_union_databases: ['google_ads_usa','google_ads_canada']

    linkedin_ads_union_schemas: ['linkedin_usa','linkedin_canada']
    linkedin_ads_union_databases: ['linkedin_usa','linkedin_canada']

    microsoft_ads_union_schemas: ['microsoft_ads_usa','microsoft_ads_canada']
    microsoft_ads_union_databases: ['microsoft_ads_usa','microsoft_ads_canada']

    pinterest_ads_union_schemas: ['pinterest_usa','pinterest_canada']
    pinterest_ads_union_databases: ['pinterest_usa','pinterest_canada']

    reddit_ads_union_schemas: ['reddit_ads_usa','reddit_ads_canada']
    reddit_ads_union_databases: ['reddit_ads_usa','reddit_ads_canada']

    snapchat_ads_union_schemas: ['snapchat_ads_usa','snapchat_ads_canada']
    snapchat_ads_union_databases: ['snapchat_ads_usa','snapchat_ads_canada']

    tiktok_ads_union_schemas: ['tiktok_ads_usa','tiktok_ads_canada']
    tiktok_ads_union_databases: ['tiktok_ads_usa','tiktok_ads_canada']

    twitter_ads_union_schemas: ['twitter_usa','twitter_canada']
    twitter_ads_union_databases: ['twitter_usa','twitter_canada']
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Configure types of conversion events
For the following platforms, conversion data is sent along with the type of event that you may or may not consider to be a conversion. For the most part, the packages consider **leads**, **purchases**, and **custom** user-defined events as conversions by default, but this can be configured via the appropriate variables.

| Platform    | Variable | Default Values | How to Use |
| ------------ | ----------- | -------- | ---------- |
| Facebook Ads    | `facebook_ads__conversion_action_types`    |  `offsite_conversion.fb_pixel_custom` + `offsite_conversion.fb_pixel_lead` + `onsite_conversion.lead_grouped` + `offsite_conversion.fb_pixel_purchase` + `onsite_conversion.purchase` | [Configuring Conversion Action Types](https://github.com/fivetran/dbt_facebook_ads?tab=readme-ov-file#configuring-conversion-action-types) |
| LinkedIn Ad Analytics   | `linkedin_ads__conversion_fields`   | `external_website_conversions` + `one_click_leads` | [Adding in Conversion Fields](https://github.com/fivetran/dbt_linkedin?tab=readme-ov-file#adding-in-conversion-fields-variable) |
| Reddit Ads      | `reddit_ads__conversion_event_types` | `lead` + `purchase` + `custom` | [Configure Conversion Event Types](https://github.com/fivetran/dbt_reddit_ads?tab=readme-ov-file#configure-conversion-event-types) |
| Snapchat Ads    | `snapchat_ads__conversion_fields`    | `conversion_purchases` | [Configuring Conversion Fields](https://github.com/fivetran/dbt_snapchat_ads?tab=readme-ov-file#configuring-conversion-fields) |
| Twitter Ads     | `twitter_ads__conversion_fields` AND `twitter_ads__conversion_sale_amount_fields` | `conversion_purchases_metric` + `conversion_custom_metric` AND `conversion_purchases_sale_amount` + `conversion_custom_sale_amount` | [Customizing Types of Conversions](https://github.com/fivetran/dbt_twitter?tab=readme-ov-file#customizing-types-of-conversions) |

For the other platforms, conversions are sent as a whole (though you may configure them in the platform UIs) and cannot be separated by event type in the connector data:
- Amazon Ads
- Apple Search Ads (does [not](https://github.com/fivetran/dbt_apple_search_ads/blob/main/DECISIONLOG.md#conversion-value) include `conversion_value`)
- Google Ads
- Microsoft Advertising
- Pinterest Ads
- TikTok Ads

#### Adding custom metrics to final reports

By default, this package selects `clicks`, `impressions`, `spend`, `conversions`, and `conversions_value` metrics from the upstream Ad platform reports. Additionally, each specific upstream Ad platform package allows for custom passthrough metrics to be included in the individual platform's final reports. You can find a complete list of available passthrough metric variables for each platform by referring to the relevant links below and inspecting the additional configurations for each platform:
    - [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads#optional-step-5-additional-configurations)
    - [Apple Search Ads](https://github.com/fivetran/dbt_apple_search_ads#optional-step-4-additional-configurations)
    - [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads#optional-step-4-additional-configurations)
    - [Google Ads](https://github.com/fivetran/dbt_google_ads#optional-step-4-additional-configurations)
    - [LinkedIn Ad Analytics](https://github.com/fivetran/dbt_linkedin#optional-step-4-additional-configurations)
    - [Microsoft Advertising](https://github.com/fivetran/dbt_microsoft_ads#optional-step-4-additional-configurations)
    - [Pinterest Ads](https://github.com/fivetran/dbt_pinterest#optional-step-4-additional-configurations)
    - [Reddit Ads](https://github.com/fivetran/dbt_reddit_ads#optional-step-4-additional-configurations)
    - [Snapchat Ads](https://github.com/fivetran/dbt_snapchat_ads#optional-step-4-additional-configurations)
    - [TikTok Ads](https://github.com/fivetran/dbt_tiktok_ads#optional-step-4-additional-configurations)
    - [Twitter Ads](https://github.com/fivetran/dbt_twitter#optional-step-5-additional-configurations)

Furthermore, this package allows you to include these configured upstream passthrough metrics in the final roll-up models of the combined Ad Reporting package. To include passthrough metrics in the respective final models, you need to define the following `ad_reporting__*` variables in your `dbt_project.yml` file:

```yml
vars:
  ad_reporting__account_passthrough_metrics:
    - name: view_through_conversions
  ad_reporting__campaign_passthrough_metrics: 
    - name: total_shares
  ad_reporting__ad_group_passthrough_metrics:
    - name: interactions
  ad_reporting__ad_passthrough_metrics: ## For both Ad and URL reports
    - name: video_views_captured
  ad_reporting__keyword_passthrough_metrics:
    - name: interactions
  ad_reporting__search_passthrough_metrics:
    - name: local_spend_amount
  ad_reporting__country_passthrough_metrics:
    - name: video_views
  ad_reporting__region_passthrough_metrics:
    - name: billed_engagements
```

It is important to ensure that if you want to configure a passthrough metric for an ad reporting end model, that metric **must** be included in all of your upstream variables. Additionally, the name of the metric **must** be consistent across platforms. If a certain upstream platform does not include the metric you **must** include a `transform_sql` argument to pass a null value through (see below for examples). The following configuration is an example when using the Microsoft Ads, Apple Search Ads, Google Ads, Snapchat Ads, TikTok Ads, and Reddit Ads platforms within a `dbt_project.yml` file:

>**Note**: While the below configuration is only for a subset of Ad platforms, the same strategy will be used for all other possible combinations of upstream Ad platform dependencies.

```yml
vars:
  ## Account Report Passthrough Metrics
  microsoft_ads__account_passthrough_metrics:
    - name: video_views_captured
      transform_sql: "null"
  apple_search_ads__campaign_passthrough_metrics:
    - name: video_views_captured
      transform_sql: "null"
  google_ads__account_stats_passthrough_metrics:
    - name: video_views
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  # snapchat_ads__ad_hourly_passthrough_metrics: # Defined below in the ad/url metrics therefore, not needed here but kept for documentation.
  #   - name: video_views
  #     alias: video_views_captured
  #     transform_sql: cast(video_views_captured as int64)
  tiktok_ads__ad_hourly_passthrough_metrics:
    - name: video_watched_2_s
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  reddit_ads__account_passthrough_metrics: # already includes view_through_conversions
    - name: video_watched_3_seconds
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  ad_reporting__account_passthrough_metrics:
    - name: video_views_captured

  ## Campaign Report Passthrough Metrics
  microsoft_ads__campaign_passthrough_metrics:
    - name: total_shares
      transform_sql: "null"
  google_ads__campaign_stats_passthrough_metrics:
    - name: total_shares
      transform_sql: cast(total_shares as int)
  snapchat_ads__campaign_hourly_report_passthrough_metrics:
    - name: shares
      alias: total_shares
  tiktok_ads__campaign_hourly_passthrough_metrics:
    - name: shares
      alias: total_shares
  reddit_ads__campaign_passthrough_metrics:
    - name: total_shares
      transform_sql: "null"
  ad_reporting__campaign_passthrough_metrics: 
    - name: total_shares

  ## Ad Group Report Passthrough Metrics
  microsoft_ads__ad_group_passthrough_metrics:
    - name: phone_calls
      alias: interactions
  apple_search_ads__ad_group_passthrough_metrics:
    - name: new_downloads
      alias: interactions
  google_ads__ad_group_stats_passthrough_metrics:
    - name: interactions
  snapchat_ads__ad_squad_hourly_passthrough_metrics:
    - name: saves
      alias: interactions
  tiktok_ads__ad_group_hourly_passthrough_metrics:
    - name: likes
      alias: interactions
  reddit_ads__ad_group_passthrough_metrics:
    - name: video_started
      alias: interactions
  ad_reporting__ad_group_passthrough_metrics:
    - name: interactions

## Ad and URL Report Passthrough Metrics
  microsoft_ads__ad_passthrough_metrics:
    - name: video_views_captured
      transform_sql: "null"
  apple_search_ads__ad_passthrough_metrics:
    - name: video_views_captured
      transform_sql: "null"
  google_ads__ad_stats_passthrough_metrics:
    - name: video_views
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  snapchat_ads__ad_hourly_passthrough_metrics:
    - name: video_views
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  tiktok_ads__ad_hourly_passthrough_metrics:
    - name: video_watched_2_s
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  reddit_ads__ad_passthrough_metrics:
    - name: video_watched_3_seconds
      alias: video_views_captured
      transform_sql: cast(video_views_captured as int64)
  ad_reporting__ad_passthrough_metrics:
    - name: video_views_captured

  # Keyword Report Passthrough Metrics
  microsoft_ads__keyword_passthrough_metrics:
    - name: interactions
      transform_sql: "null"
  apple_search_ads__keyword_passthrough_metrics:
    - name: new_downloads
      alias: interactions
  google_ads__keyword_stats_passthrough_metrics:
    - name: interactions
  ad_reporting__keyword_passthrough_metrics:
    - name: interactions

  # Search Report Passthrough Metrics
  microsoft_ads__search_passthrough_metrics:
    - name: local_spend_amount
      transform_sql: "null"
  apple_search_ads__search_term_passthrough_metrics:
    - name: local_spend_amount
      transform_sql: "cast(local_spend_amount as int64)"
  google_ads__search_term_keyword_stats_passthrough_metrics:
    - name: local_spend_amount
      transform_sql: "null"
  ad_reporting__search_passthrough_metrics:
    - name: local_spend_amount

  # Country Report Passthrough Metrics
  facebook_ads__demographics_country_passthrough_metrics:
    - name: cpm
  linkedin_ads__monthly_ad_analytics_by_member_country_passthrough_metrics: 
    - name: cpm 
      transform_sql: "null"
  microsoft_ads__geographic_passthrough_metrics:
    - name: average_cpm
      alias: cpm
  pinterest__pin_promotion_targeting_report_passthrough_metrics:
    - name: cpm_in_micro_dollar
      alias: cpm
      transform_sql: cpm / 1000000.0
  reddit_ads__campaign_country_passthrough_metrics:
    - name: cpm 
      transform_sql: "null"
  snapchat_ads__campaign_daily_country_report_passthrough_metrics: 
    - name: cpm 
      transform_sql: "null"
  tiktok_ads__campaign_country_report_passthrough_metrics:
    - name: cpm 
  twitter_ads__campaign_locations_report_passthrough_metrics:
    - name: cpm 
      transform_sql: "null"
  ad_reporting__country_passthrough_metrics:
    - name: cpm

  # Region Report Passthrough Metrics
  facebook_ads__demographics_region_passthrough_metrics:
    - name: cpm
  linkedin_ads__monthly_ad_analytics_by_member_region_passthrough_metrics: 
    - name: cpm 
      transform_sql: "null"
  microsoft_ads__geographic_passthrough_metrics:
    - name: average_cpm
      alias: cpm
  pinterest__pin_promotion_targeting_report_passthrough_metrics:
    - name: cpm_in_micro_dollar
      alias: cpm
      transform_sql: cpm / 1000000.0
  snapchat_ads__campaign_daily_region_report_passthrough_metrics: 
    - name: cpm 
      transform_sql: "null"
  twitter_ads__campaign_regions_report_passthrough_metrics:
    - name: cpm 
      transform_sql: "null"
  ad_reporting__region_passthrough_metrics:
    - name: cpm
```

>**Note**: Please make sure to use due diligence when adding metrics to these models. The metrics added by default (`clicks`, `impressions`, `spend`, `conversions`, and `conversions_value`) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example metric averages, which may be inaccurately represented at the grain for reports created in this package. You will want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package.

#### Disabling null URL filtering from URL reports
The default behavior for the `ad_reporting__url_report` end model is to filter out records having null URL fields, however, you are able to turn off this filter if needed. To turn off the filter, include the below in your `dbt_project.yml` file. This variable will affect ALL Fivetran platform packages enabled in Ad Reporting, therefore either all URL reports will have null URLs filtered, or all URL reports will have null URLs included.

```yml
vars:
  ad_reporting__url_report__using_null_filter: False # Default is True.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available for sources in which you are unioning together multiple connections.
 
```yml
vars:
    <default_source_table_name>_identifier: your_table_name 
```

</details>
<br>

### (Optional) Step 7: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>
<br>

### (Optional) Step 8: Use predefined Metrics and the dbt Semantic Layer
<details><summary>Expand for details</summary>

On top of the `ad_reporting__ad_report` final model, the Ad Reporting dbt package defines common [Metrics](https://docs.getdbt.com/docs/build/build-metrics-intro) using [MetricFlow](https://docs.getdbt.com/docs/build/about-metricflow) that can be queried with the [dbt Semantic Layer](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl). These metrics include:
- Spend
- Impressions
- Clicks
- Cost per click
- Clickthrough rate
- Bounce rate
- Count of active ads
- Average spend
- Average non-zero spend

You can find the supported dimensions and full definitions of these metrics [here](https://github.com/fivetran/dbt_ad_reporting/blob/main/models/ad_reporting_metrics.yml), and the semantic model definitions [here](https://github.com/fivetran/dbt_ad_reporting/blob/main/models/metrics/models/semantic_models/ad_reporting__ad_report.yaml).

Refer to the Semantic Layer [quickstart guide](https://docs.getdbt.com/docs/use-dbt-semantic-layer/quickstart-sl) for instructions on how to get setup with the dbt Semantic Layer and start querying these metrics.

**Metricflow Time Spine Configuration**
This package includes a model called `metricflow_time_spine.sql` that MetricFlow requires to build cumulative metrics. Documentation on the metricflow time spine model can be [found here.](https://docs.getdbt.com/docs/build/metricflow-time-spine) If you have already configured a metricflow time spine model in your project, you will need to disable the one in this package by defining the `ad_reporting__metricflow_time_spine_enabled` variable as `false` in your project.

```yml
## root dbt_project.yml
vars:
  ad_reporting__metricflow_time_spine_enabled: false ## True by default
```
Additionally, the `fivetran_get_base_dates` macro is used in the generation of the `metricsflow_time_spine` model. This macro requires the `dbt_date:time_zone` variable to be defined in the project to generate a time spine based on the defined time zone. The default value in this package is `America/Los_Angeles`. However, you may override this variable in your own project if you wish. See below for an example.

>**Note**: This `dbt_date:time_zone` variable is defined under the `ad_reporting` hierarchy within this package and should not adjust any local global variable values in your project if you already have this variable defined. 

You may specify any [valid timezone string](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in place of America/Los_Angeles. For example, use America/New_York for East Coast Time.

```yml
## root dbt_project.yml
vars:
  "dbt_date:time_zone": "America/New_York" # Default is "America/Los_Angeles"
```

**Semantic Manifest**
You may notice a new run artifact called `semantic_manifest.json`. This file serves as the integation point between dbt-core and metricflow, and contains all the information MetricFlow needs to build a semantic graph, and generate SQL from query requests. You can learn more about the semantic manifest file [in the docs](https://docs.getdbt.com/docs/dbt-cloud-apis/sl-manifest).

> **Note**: Metricflow is only supported in dbt>=v1.6.0, therefore, please take note of the correct dbt version.

</details>
<br>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` we highly recommend you remove them to ensure there are no package version conflicts.**

```yml
packages: 
  - package: fivetran/fivetran_utils
    version: [">=0.4.0", "<0.5.0"]

  - package: dbt-labs/spark_utils
    version: [">=0.3.0", "<0.4.0"]

  - package: dbt-labs/dbt_utils
    version: [">=1.0.0", "<2.0.0"]

  - package: fivetran/amazon_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/apple_search_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/facebook_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/google_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/linkedin
    version: [">=1.0.0", "<1.1.0"]

  - package: fivetran/microsoft_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/pinterest
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/reddit_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/snapchat_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/tiktok_ads
    version: [">=1.0.0", "<1.1.0"] 

  - package: fivetran/twitter_ads
    version: [">=1.0.0", "<1.1.0"]
```

### Other Dependencies
The country names in `ad_reporting__monthly_campaign_country_report` are standardized to align with official ISO-3166 names. Greater *global* region names (ex: Southern Asia) are also included and leveraged from [lukes/ISO-3166-Countries-with-Regional-Codes](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes).

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_ad_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Opinionated Decisions
In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made in the [DECISIONLOG.md](https://github.com/fivetran/dbt_ad_reporting/blob/main/DECISIONLOG.md), and will continue to update as the package evolves. We are always open to and encourage feedback on these choices, and the package in general.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_ad_reporting/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_ad_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
