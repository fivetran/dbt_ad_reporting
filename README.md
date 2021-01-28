# Ad Reporting

This dbt package aggregates and models data from six different Fivetran advertising connectors. The package standardises the schemas from the various ad connectors and creates a single reporting model for all activity.

Currently, this package supports the following ad connector types:
> NOTE: You do _not_ need to have all six ad connector types to use this package, though you should have at least two.
* [LinkedIn Ads](https://github.com/fivetran/dbt_linkedin)
* [Pinterest Ads](https://github.com/fivetran/dbt_pinterest_ads)
* [Microsoft Ads](https://github.com/fivetran/dbt_microsoft_ads)
* [Google Ads](https://github.com/fivetran/dbt_google_ads)
* [Twitter Ads](https://github.com/fivetran/dbt_twitter)
* [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads)

## Models

This package contains a number of models, which all build up to the `ad_reporting` model. The `ad_reporting` model combines the data from all of the data sources. A dependency on all the required dbt packages is declared in this package's `packages.yml` file, so it will automatically download them when you run `dbt deps`. The primary outputs of this package are described below.

| **model**    | **description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| ad_reporting | Each record represents the daily ad performance from all sources, including information about the UTM parameters you used. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

### Source selection

The package assumes that all source models are 'enabled', so it will look to pull data from all of the data sources listed [above](https://github.com/fivetran/dbt_ad_reporting/edit/master/README.md#adreporting). If you don't want to use certain data sources, disable those sources' models in this package by setting the relevant variables to `false`:

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
```

Next, you must disable the models in the unwanted data source's related package, which has its own configuration. Disable the relevant models under the models section of your `dbt_project.yml` file by setting the `enabled` value to `false`:

```yml
models:
  pinterest:
    enabled: false
  microsoft_ads:
    enabled: false
  linkedin:
    enabled: false
  linkedin:
    enabled: false
  twitter_ads:
    enabled: false
  facebook_ads:
    enabled: false
```

### Source Data

By default, this package looks for your advertising data in your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your advertising data is stored, add the relevant `_database` variables to your `dbt_project.yml` file (see below). 

By default, this package also looks for specific schemas from each of your data sources. The schemas from each source are highlighted in the code snippet below. If your data is stored in a different schema, add the relevant `_schema` variables to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    microsoft_ads_schema: microsoft_ads
    microsoft_ads_database: your_database_name
    linkedin_schema: linkedin_ads 
    linkedin_database: your_database_name  
    pinterest_schema: pinterest_ads 
    pinterest_database: your_database_name 
    twitter_ads_schema: twitter_ads
    twitter_ads_database: your_database_name  
    facebook_ads_schema: facebook_ads
    facebook_ads_database: your_database_name 
    google_ads_schema: adwords
    google_ads_database: your_database_name 
```

For more configuration information, see the relevant data source packages ([listed above](https://github.com/fivetran/dbt_ad_reporting/edit/master/README.md#adreporting)).

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Find [dbt events](https://events.getdbt.com) near you
- Check out [dbt's blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
