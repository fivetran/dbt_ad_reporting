## Decision Log

### Reporting Hierarchy
In our research, we have found the typical ad reporting hierarchy to be as follows:
```
Account
└── Campaign
    ├── Ad Group
    │   ├── Ad
    ├──  URL
    ├── Search
    └── Keyword
```
Where Account > Campaign > Ad Group > Ad and Search and Keyword reports are created at the Ad Group Level. Depending on the platform, URL reports can be at the Ad Level or the Ad Group level so we have made the decision to provide only reporting at the Ad Group level to be inclusive of all our platforms.

### Linkedin Campaign Group and Campaign Mapping
Linkedin's "campaign group" reporting is the equivalent to all other platforms' "campaign" reporting; similarly, Linkedin's "campaign" reporting is equivalent to all other platforms' "ad group" reporting. Therefore, the Ad Reporting campaign model and ad group model each reflect the proper roll up for Linkedin with respects to other platforms.

### Snapchat Ad Account Report Metrics Associated with Deleted Entities
Snapchat Ads will hard-delete entities (i.e. ads, ad squads, campaigns, accounts) from their `*_history` tables but retain associated records in their respective `*_hourly_report` tables. This typically does not pose an issue for our `not_null` tests on our Ad Reporting and Snapchat Ads end models, as most entities have their own `<entity>_hourly_report` source tables that come with the appropriate entity-level ID. However, `snapchat_ads__account_report` (and the downstream `ad_reporting__account_report` model) draws from the Snapchat `ad_hourly_report` table, rolls it up to the account level, and joins in the ad `account_id` using history tables. Thus, if any ad report record is associated with a deleted ad, campaign, ad squad, or account, the ad `account_id` will be `null`.

We have opted to keep these records in `snapchat_ads__account_report` and `ad_reporting__account_report`, as it may be valuable to know that non-zero ad metrics are associated with deleted entities (though null-account Snapchat records will be grouped together). However, we have changed the severity of the `not_null` test on ad `account_id` to be `warn` instead of `error`.

If you would like to disable this `not_null` test completely to avoid warnings, add the following to your root project `dbt_project.yml`:
```yml
tests:
  snapchat_ads:
    not_null_snapchat_ads__account_report_ad_account_id:
      +enabled: false
  ad_reporting:
    not_null_ad_reporting__account_report_account_id:
      +enabled: false
```

### Timezone Considerations

The table below documents timezone differences across platforms in the `dbt_ad_reporting` package. These differences exist due to the following reasons:

- Ad platforms send pre-aggregated data that cannot be back-calculated to a finer granularity to account for timezone differences. 
- Some platforms offer hourly report data, which could potentially be standardized. However, this approach does not ensure full coverage due to non-standard timezones, such as ±30-minute and ±45-minute offsets.

Although this presents challenges within this package, customers can achieve standardization by configuring all Ad accounts and connectors to UTC whenever possible.

| Platform | Grain of Data | Timezone | Hourly Custom Reports? | Can Configure Time Zones for Custom Reports? |
|----------|---------------|----------|------------------------|----------------------------------------------|
| Amazon Ads | Day | CLIENT SET | No | No |
| Apple Search Ads | Day | CLIENT SET | Yes | ORTZ, UTC |
| Facebook Ads | Day | CLIENT SET | No | No |
| Google Ads | Hour - aggregated to daily in the package | CLIENT SET | Yes | No |
| Linkedin Ad Analytics | Day | UTC | No | No |
| Microsoft Advertising | Hour - aggregated to daily in the package | CLIENT SET | No | No |
| Pinterest Ads | Hour - aggregated to daily in the package | UTC | Yes | No |
| Reddit Ads | Day | UTC | No | Customer can choose timezone in custom reports |
| Snapchat Ads | Hour | UTC | No | No |
| TikTok Ads | Hour | UTC | Yes | No |
| Twitter Ads | Day | CLIENT SET | No | No |
