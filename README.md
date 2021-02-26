# Ad Reporting

This package models data from a number of different Fivetran advertising/marketing connectors. The main focus of the package is to standardize the schemas from the various ad connectors and create a single reporting model for all activity.

Currently, this package supports the following ad sources:
* [LinkedIn Ads](https://github.com/fivetran/dbt_linkedin)
* [Pinterest Ads](https://github.com/fivetran/dbt_pinterest_ads)
* [Microsoft Ads](https://github.com/fivetran/dbt_microsoft_ads)
* [Google Ads](https://github.com/fivetran/dbt_google_ads)
* [Twitter Ads](https://github.com/fivetran/dbt_twitter)
* [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads)

## Models

This package contains a number of models, all building up to the `ad_reporting` model, which is a combination of all the data sources. A dependency on all the required dbt packages is declared in this package's `packages.yml` file, so it will automatically download them when you run `dbt deps`. The primary output of this package are described below.

| **model**    | **description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| ad_reporting | Each record represents the daily ad performance from all sources, including information about the used UTM parameters. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

### Source selection

The package assumes that all packages are 'enabled', i.e. it will look to pull data from all the data sources listed above. If that is not the case, please set the relevant following variables to `false` in order to disable the relevant models from this pacakge:
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

You will also need to disable the models from the related package, which require their own configuration. To do so, disable the models under the models section of your `dbt_project.yml` file:

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
    enabled: false
  facebook_ads_source:
    enabled: false
  facebook_ads_backwards_compatibility:
    enabled: false
  # disable both google ads models if not using google ads
  google_ads:
    enabled: false
  google_ads_source:
    enabled: false
```

### Source Data

By default, this package will look for your advertising data in your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your advertising data is stored, please add the relevant `_database` variables (below) to your `dbt_project.yml` file.

By default, this package will also look to specific schemas for each of your data sources. The schemas for each source are highlighted in the code snippet below. If your data is stored in a different schema, please add the relevant `_schema` variables (below) to your `dbt_project.yml` file.

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
```

For additional configurations information, please visit the relevant packages, as listed above.

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:

- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
