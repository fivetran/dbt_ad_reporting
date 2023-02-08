<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Ad Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_ad_reporting/))
# 📣 What does this dbt package do?
- Standardizes schemas from various ad platform connectors and creates reporting models for clicks, spend and impressions aggregated to the account, campaign, ad group, ad, keyword and search levels. 
- Currently supports the following Fivetran ad platform connectors:
    - [Amazon Ads](https://github.com/fivetran/dbt_amazon_ads)
    - [Apple Search Ads](https://github.com/fivetran/dbt_apple_search_ads)
    - [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads)
    - [Google Ads](https://github.com/fivetran/dbt_google_ads)
    - [LinkedIn Ad Analytics](https://github.com/fivetran/dbt_linkedin)
    - [Microsoft Advertising](https://github.com/fivetran/dbt_microsoft_ads)
    - [Pinterest Ads](https://github.com/fivetran/dbt_pinterest)
    - [Snapchat Ads](https://github.com/fivetran/dbt_snapchat_ads)
    - [TikTok Ads](https://github.com/fivetran/dbt_tiktok_ads)
    - [Twitter Ads](https://github.com/fivetran/dbt_twitter)
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
- Generates a comprehensive data dictionary of your source and modeled Ad Reporting data via the [dbt docs site](https://fivetran.github.io/dbt_ad_reporting/)

Refer to the table below for a detailed view of final models materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_ad_reporting/#!/overview) for more details about these models. 

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ad_reporting__account_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__account_report)             | Each record represents daily metrics by account                                            |
| [ad_reporting__campaign_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__campaign_report)     | Each record represents daily metrics by campaign and account. |
| [ad_reporting__ad_group_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__ad_group_report)     | Each record represents daily metrics by ad group, campaign and account.                            |
| [ad_reporting__ad_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__ad_report)    | Each record represents daily metrics by ad, ad group, campaign and account.                            |
| [ad_reporting__keyword_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__keyword_report)   | Each record represents daily metrics by keyword, ad group, campaign and account.                           |                          |
| [ad_reporting__search_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__search_report) | Each record represents daily metrics by search query, ad group, campaign and account.                        |
| [ad_reporting__url_report](https://fivetran.github.io/dbt_ad_reporting/#!/model/model.ad_reporting.ad_reporting__url_report) | Each record represents daily metrics by URL (and if applicable, URL UTM parameters), ad group, campaign and account.                        |

> The individual platform models may have additional platform-specific metrics and fields better suited for deep-dive analyses at the platform level.

# 🎯 How do I use the dbt package?
## Step 1: Pre-Requisites
**Connector**: Have at least one of the below supported Fivetran ad platform connectors syncing data into your warehouse. This package currently supports:
    - [Amazon Ads](https://fivetran.com/docs/applications/amazon-ads)
    - [Apple Search Ads](https://fivetran.com/docs/applications/apple-search-ads)
    - [Facebook Ads](https://fivetran.com/docs/applications/facebook-ads)
    - [Google Ads](https://fivetran.com/docs/applications/google-ads)
    - [LinkedIn Ad Analytics](https://fivetran.com/docs/applications/linkedin-ads)
    - [Microsoft Advertising](https://fivetran.com/docs/applications/microsoft-advertising)
    - [Pinterest Ads](https://fivetran.com/docs/applications/pinterest-ads)
    - [Snapchat Ads](https://fivetran.com/docs/applications/snapchat-ads)
    - [TikTok Ads](https://fivetran.com/docs/applications/tiktok-ads)
    - [Twitter Ads](https://fivetran.com/docs/applications/twitter-ads)
> While you need only one of the above connectors to utilize this package, we recommend having at least two to gain the rollup benefit of this package.

- **Database support**: This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, **Postgres** and **Databricks**. Ensure you are using one of these supported databases.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` as well as the `calogica/dbt_expectations` then the `google_ads_source` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']

  - macro_namespace: dbt_expectations
    search_order: ['google_ads_source', 'dbt_expectations']
```

## Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/ad_reporting
    version: [">=1.2.0", "<1.3.0"]
```
## Step 3: Configure Database and Schema Variables
By default, this package looks for your ad platform data in your target database. If this is not where your app platform data is stored, add the relevant `<connector>_database` variables to your `dbt_project.yml` file (see below).

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

    twitter_ads_schema: twitter_ads
    twitter_ads_database: your_database_name  

    snapchat_schema: snapchat_ads
    snapchat_database: your_database_name 
    
    tiktok_ads_schema: tiktok_ads
    tiktok_ads_database: your_database_name 
```

## Step 4: Enabling/Disabling Models
This package takes into consideration that not every account will have every feature enabled per platform. If your syncs exclude certain tables, it is because you either don't use that functionality in your respective ad platforms or have actively excluded some tables from your syncs. 

### Disable Platform Specific Reporting
If you would like to disable all reporting for any specific platform, please include the respective variable(s) in your `dbt_project.yml`. 

```yml
vars:
  ad_reporting__amazon_ads_enabled: False # by default this is assumed to be True
  ad_reporting__apple_search_ads_enabled: False # by default this is assumed to be True
  ad_reporting__pinterest_ads_enabled: False # by default this is assumed to be True
  ad_reporting__microsoft_ads_enabled: False # by default this is assumed to be True
  ad_reporting__linkedin_ads_enabled: False # by default this is assumed to be True
  ad_reporting__google_ads_enabled: False # by default this is assumed to be True
  ad_reporting__twitter_ads_enabled: False # by default this is assumed to be True
  ad_reporting__facebook_ads_enabled: False # by default this is assumed to be True
  ad_reporting__snapchat_ads_enabled: False # by default this is assumed to be True
  ad_reporting__tiktok_ads_enabled: False # by default this is assumed to be True
```
### Enable/Disable Specific Reports within Platforms
For **Apple Search Ads**, if you are not utilizing the search functionality, you may choose to update the respective variable below.

For **Twitter Ads**, if you are tracking keyword performance, you may choose to update the corresponding variable below.

Add the following variables to your dbt_project.yml file

```yml
vars:
  apple_search_ads__using_search_terms: False # by default this is assumed to be True
  twitter_ads__using_keywords: False # by default this is assumed to be True
```

## (Recommended) Step 5: Change the Build Schema
By default this package will build all models in your `<target_schema>` with the respective package suffixes (see below). This behavior can be tailored to your preference by making use of custom schemas. If you would like to override the current naming conventions, please add the following configuration to your `dbt_project.yml` file and rename `+schema` configs:

```yml
models:  
  ad_reporting:
    +schema: ad_reporting

  amazon_search_ads:
    +schema: amazon_ads
  amazon_ads_source:
    +schema: amazon_ads_source

  apple_search_ads:
    +schema: apple_search_ads
  apple_search_ads_source:
    +schema: apple_search_ads_source
  
  facebook_ads:
    +schema: facebook_ads
  facebook_ads_source:
    +schema: facebook_ads_source
  
  google_ads:
    +schema: google_ads
  google_ads_source:
    +schema: google_ads_source

  linkedin:
    +schema: linkedin
  linkedin_source:
    +schema: linkedin_source

  microsoft_ads:
    +schema: microsoft_ads
  microsoft_ads_source:
    +schema: microsoft_ads_source

  pinterest:
    +schema: pinterest
  pinterest_source:
    +schema: pinterest_source
  
  twitter_ads:
    +schema: twitter_ads
  twitter_ads_source:
    +schema: twitter_ads_source
  
  snapchat_ads:
    +schema: snapchat_ads
  snapchat_ads_source:
    +schema: snapchat_ads_source
  
  tiktok_ads:
    +schema: tiktok_ads
  tiktok_ads_source:
    +schema: tiktok_ads_source
```

> Provide a blank `+schema: ` to write to the `target_schema` without any suffix.

## (Optional) Step 6: Additional configurations
<details><summary>Expand for details</summary>
<br>

## Disabling null URL filtering from URL reports
The default behavior for the `ad_reporting__url_report` end model is to filter out records having null URL fields, however, you are able to turn off this filter if needed. To turn off the filter, include the below in your `dbt_project.yml` file. This variable will affect ALL Fivetran platform packages enabled in Ad Reporting, therefore either all URL reports will have null URLs filtered, or all URL reports will have null URLs included.

```yml
vars:
  ad_reporting__url_report__using_null_filter: False # Default is True.
```

### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See the Apple Store [`dbt_project.yml`](https://github.com/fivetran/dbt_apple_store_source/blob/main/dbt_project.yml)  and Google Play [`dbt_project.yml`](https://github.com/fivetran/dbt_google_play_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    <default_source_table_name>_identifier: your_table_name 
```
    
</details>
<br>

## (Optional) Step 7: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>
<br>

## (Optional) Step 8: Use predefined Metrics
<details><summary>Expand for details</summary>

On top of the `ad_reporting__ad_report` final model, the Ad Reporting dbt package defines common [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics), including:
- Spend
- Impressions
- Clicks
- Cost per click
- Clickthrough rate
- Bounce rate
- Count of active ads
- Average spend
- Average non-zero spend

You can find the supported dimensions and full definitions of these metrics [here](https://github.com/fivetran/dbt_ad_reporting/blob/main/models/ad_reporting_metrics.yml).

To use dbt Metrics, add the [dbt metrics package](https://github.com/dbt-labs/dbt_metrics) to your project's `packages.yml` file:
```yml
packages:
  - package: dbt-labs/metrics
    version: [">=0.3.0", "<0.4.0"]
```
> **Note**: The Metrics package has stricter dbt version requirements. As of today, the latest version of Metrics (v0.3.5) requires dbt `[">=1.2.0-a1", "<2.0.0"]`.

To utilize the Ad Reporting's pre-defined metrics in your code, refer to the [dbt metrics package](https://github.com/dbt-labs/dbt_metrics) usage instructions and the example below:
```sql
select *
from {{ metrics.calculate(
        metric('clicks'),
        grain='month',
        dimensions=['platform', 
                    'campaign_id', 
                    'campaign_name'
        ],
        secondary_calculations=[
            metrics.period_over_period(comparison_strategy='difference', interval=1, alias='diff_last_mth'),
            metrics.period_over_period(comparison_strategy='ratio', interval=1, alias='ratio_last_mth')
        ]
) }}
```

</details>
<br>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**

```yml
packages: 
  - package: fivetran/fivetran_utils
    version: [">=0.3.0", "<0.4.0"]

  - package: dbt-labs/dbt_utils
    version: [">=0.8.0", "<0.9.0"]

  - package: calogica/dbt_expectations
    version: [">=0.5.0", "<0.6.0"]

  - package: fivetran/amazon_ads
    version: [">=0.1.0", "<0.2.0"]
  
  - package: fivetran/amazon_ads_source
    version: [">=0.1.0", "<0.2.0"]

  - package: fivetran/apple_search_ads
    version: [">=0.2.0", "<0.3.0"]

  - package: fivetran/apple_search_ads_source
    version: [">=0.2.0", "<0.3.0"]
  
  - package: fivetran/facebook_ads
    version: [">=0.6.0", "<0.7.0"]

  - package: fivetran/facebook_ads_source
    version: [">=0.6.0", "<0.7.0"]
  
  - package: fivetran/google_ads
    version: [">=0.9.0", "<0.10.0"]

  - package: fivetran/google_ads_source
    version: [">=0.9.0", "<0.10.0"]

  - package: fivetran/pinterest
    version: [">=0.7.0", "<0.8.0"]

  - package: fivetran/pinterest_source
    version: [">=0.7.0", "<0.8.0"]

  - package: fivetran/microsoft_ads
    version: [">=0.6.0", "<0.7.0"]

  - package: fivetran/microsoft_ads_source
    version: [">=0.7.0", "<0.8.0"]

  - package: fivetran/linkedin
    version: [">=0.7.0", "<0.8.0"]

  - package: fivetran/linkedin_source
    version: [">=0.7.0", "<0.8.0"]

  - package: fivetran/twitter_ads
    version: [">=0.6.0", "<0.7.0"]

  - package: fivetran/twitter_ads_source
    version: [">=0.6.0", "<0.7.0"]

  - package: fivetran/snapchat_ads
    version: [">=0.5.0", "<0.6.0"]

  - package: fivetran/snapchat_ads_source
    version: [">=0.5.0", "<0.6.0"]

  - package: fivetran/tiktok_ads
    version: [">=0.3.0", "<0.4.0"]

  - package: fivetran/tiktok_ads_source
    version: [">=0.3.0", "<0.4.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_ad_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Opinionated Decisions
In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made in the [DECISIONLOG.md](https://github.com/fivetran/dbt_ad_reporting/blob/main/DECISIONLOG.md), and will continue to update as the package evolves. We are always open to and encourage feedback on these choices, and the package in general.

## Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you encounter any questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_ad_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or send us an email at solutions@fivetran.com.