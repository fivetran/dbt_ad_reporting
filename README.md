[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Ad Reporting

This dbt package aggregates and models data from multiple Fivetran advertising connectors. The package standardizes the schemas from the various ad connectors and creates a single reporting model for all activity. It enables you to analyze your daily ad spend, clicks, and impressions by campaigns, ad groups, and UTM parameters.

Currently, this package supports the following ad connector types:
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
* [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads)
* [Google Ads](https://github.com/fivetran/dbt_google_ads)
* [LinkedIn Ad Analytics](https://github.com/fivetran/dbt_linkedin)
* [Microsoft Advertising](https://github.com/fivetran/dbt_microsoft_ads)
* [Pinterest Ads](https://github.com/fivetran/dbt_pinterest)
* [Twitter Ads](https://github.com/fivetran/dbt_twitter)
* [Snapchat Ads](https://github.com/fivetran/dbt_snapchat_ads)

## Models

This package contains a number of models, which all build up to the final `ad_reporting` model. The `ad_reporting` model combines the data from all of the connectors. A dependency on all the required dbt packages is declared in this package's `packages.yml` file, so it will automatically download them when you run `dbt deps`. The primary outputs of this package are described below.

| **model**    | **description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| ad_reporting | Each record represents the daily ad performance from all connectors, including information about the UTM parameters you used. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/ad_reporting
    version: 0.6.0-b1
```

## Configuration

### Connector selection

The package assumes that all connector models are enabled, so it will look to pull data from all of the connectors listed [above](https://github.com/fivetran/dbt_ad_reporting/edit/master/README.md#adreporting). If you don't want to use certain connectors, disable those connectors' models in this package by setting the relevant variables to `false`:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  ad_reporting__pinterest_enabled: False
  ad_reporting__microsoft_ads_enabled: False
  ad_reporting__linkedin_ads_enabled: False
  ad_reporting__google_ads_enabled: False
  ad_reporting__twitter_ads_enabled: False
  ad_reporting__facebook_ads_enabled: False
  ad_reporting__snapchat_ads_enabled: False
```

Next, you must disable the models in the unwanted connector's related package, which has its own configuration. Disable the relevant models under the models section of your `dbt_project.yml` file by setting the `enabled` value to `false`. 

*Only include the models you want to disable.  Default values are generally `true` but that is not always the case.*

```yml
models:
  # disable both pinterest models if not using pinterest ads
  pinterest:
    enabled: false
  pinterest_source:
    enabled: false
  
  # disable both microsoft ads models if not using microsoft ads
  microsoft_ads:
    enabled: false
  microsoft_ads_source:
    enabled: false
  
  # disable both linkedin ads models if not using linkedin ads
  linkedin:
    enabled: false
  linkedin_source:
    enabled: false
  
  # disable both twitter ads models if not using twitter ads
  twitter_ads:
    enabled: false
  twitter_ads_source:
    enabled: false
  
  # disable all three facebook ads models if not using facebook ads
  facebook_ads:
    enabled: false #IF YOU ARE USING FACEBOOK, DELETE THIS CONFIG, DO NOT SIMPLY SET TO TRUE
  facebook_ads_source:
    enabled: false #IF YOU ARE USING FACEBOOK, DELETE THIS CONFIG, DO NOT SIMPLY SET TO TRUE
  facebook_ads_creative_history:
    enabled: false #IF YOU ARE USING FACEBOOK, DELETE THIS CONFIG, DO NOT SIMPLY SET TO TRUE
  
  # disable both google ads models if not using google ads
  google_ads:
    enabled: false #IF YOU ARE USING GOOGLE ADS, DELETE THIS CONFIG, DO NOT SIMPLY SET TO TRUE
  google_ads_source:
    enabled: false #IF YOU ARE USING GOOGLE ADS, DELETE THIS CONFIG, DO NOT SIMPLY SET TO TRUE
  
  # disable both snapchat ads models if not using snapchat ads
  snapchat_ads:
    enabled: false
  snapchat_ads_source:
    enabled: false
```
### Google Ads and Adwords API Configuration
This package allows users to leverage either the Adwords API or the Google Ads API if you have enabled the Google Ads connector. You will be able to determine which API your Google Ads connector is using by navigating within your Fivetran UI to the `setup` tab -> `edit connection details` link -> and reference the `API configuration` used. You will want to refer to the respective configuration steps below based off the API used by your connector. 

#### Google Ads API
If your Google Ads connector is setup using the Google Ads API then you will need to configure your `dbt_project.yml` with the below variable:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    api_source: google_ads  ## adwords by default and is case sensitive!
```
#### Adwords API
If your Google Ads connector is setup using the Adwords API (default) then you will want to follow the steps outlined in the [dbt_google_ads](https://github.com/fivetran/dbt_google_ads#adwords-api-configuration) package for configuring your package to leverage the adwords API.

### Data Location

By default, this package looks for your advertising data in your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your advertising data is stored, add the relevant `_database` variables to your `dbt_project.yml` file (see below). 

By default, this package also looks for specific schemas from each of your connectors. The schemas from each connector are highlighted in the code snippet below. If your data is stored in a different schema, add the relevant `_schema` variables to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    microsoft_ads_schema: bingads
    microsoft_ads_database: your_database_name
    linkedin_schema: linkedin_ads 
    linkedin_database: your_database_name  
    pinterest_schema: pinterest
    pinterest_database: your_database_name 
    twitter_ads_schema: twitter_ads
    twitter_ads_database: your_database_name  
    facebook_ads_schema: facebook_ads
    facebook_ads_database: your_database_name 
    google_ads_schema: adwords
    google_ads_database: your_database_name 
    snapchat_schema: snapchat_ads
    snapchat_database: your_database_name 
```

For more configuration information, see the relevant connectors ([listed above](https://github.com/fivetran/dbt_ad_reporting/edit/master/README.md#adreporting)).

### Changing the Build Schema (RECOMMENDED)
By default this package will build all models in your <target_schema>.  This behavior can be tailored to your preference by making use of custom schemas. We highly recommend use of custom schemas for this package, as multiple sources are involved.  To do so, add the following configuration to your `dbt_project.yml` file: 

```yml
# dbt_project.yml

...
models:  
  pinterest:
    +schema: pinterest
  pinterest_source:
    +schema: pinterest_source
  
  microsoft_ads:
    +schema: microsoft_ads
  microsoft_ads_source:
    +schema: microsoft_ads_source
  
  linkedin:
    +schema: linkedin
  linkedin_source:
    +schema: linkedin_source
  
  twitter_ads:
    +schema: twitter_ads
  twitter_ads_source:
    +schema: twitter_ads_source

  facebook_ads:
    +schema: facebook_ads
  facebook_ads_source:
    +schema: facebook_ads_source
  facebook_ads_creative_history:
    +schema: facebook_ads
  
  google_ads:
    +schema: google_ads
  google_ads_source:
    +schema: google_ads_source
  
  snapchat_ads:
    +schema: snapchat_ads
  snapchat_ads_source:
    +schema: snapchat_ads_source

```

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
