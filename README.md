# Ad Reporting

This package models data from a number of different Fivetran advertising/marketing connectors. The main focus of the package is to standardise the schemas from the various ad connectors and create a single reporting model for all activity.

Currently, this package supports the following ad sources:
* [LinkedIn Ads](https://github.com/fivetran/dbt_linkedin)
* [Pinterest Ads](https://github.com/fivetran/dbt_pinterest_ads)
* [Bing Ads](https://github.com/fivetran/dbt_bing_ads)

## Models

This package contains a number of models, all building up to the `ad_reporting` model, which is a combination of all the data sources. A dependency on all the required dbt packages is declared in this package's `packages.yml` file, so it will automatically download them when you run `dbt deps`. The primary outputs of this package are described below.

| **model**    | **description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| ad_reporting | Each record represents the daily ad performance from all sources, including information about the used UTM parameters. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

### Source selection

The package assumes that all packages are 'enabled', i.e. it will look to pull data from all the data sources listed above. If that is not the case, please set the relevant following variables to `false`:
```yml
# dbt_project.yml

...
config-version: 2

vars:
  ad_reporting__pinterest_enabled: true
  ad_reporting__bing_ads_enabled: true
  ad_reporting__linkedin_ads_enabled: true
```

### Source Data

By default, this package will look for your advertising data in your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your advertising data is stored, please add the relevant `_database` variables (below) to your `dbt_project.yml` file.

By default, this package will also look to specific schemas for each of your data sources. The schemas for each source are highlighted in the code snippet below. If your data is stored in a different schema, please add the relevant `_schema_` variables (below) to your `dbt_project.yml` file.

```yml
# dbt_project.yml

...
config-version: 2

vars:
    bing_ads_schema: your_database_name
    bing_ads_database: bing_ads 
    linkedin_schema: your_database_name
    linkedin_database: linkedin_ads 
    pinterest_schema: your_database_name
    pinterest_database: pinterest_ads 
```

For additional configurations information, please visit the relevant packages, as listed above.

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
