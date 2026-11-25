{% docs account_id %} The ID representing the account in the ad platform. {% enddocs %}

{% docs account_name %} The name of the account, if present in the source data.{% enddocs %}

{% docs ad_group_id %} The ID representing the ad group, if present in the source data.{% enddocs %}

{% docs ad_group_name %} The name of the ad group, if present in the source data.{% enddocs %}

{% docs ad_id %}The ID representing the ad, if present in the source data. {% enddocs %}

{% docs ad_name %} The name of the ad, if present in the source data.{% enddocs %}

{% docs base_url %} The base URL of the ad's landing page. {% enddocs %}

{% docs campaign_id %} The ID representing the campaign, if present in the source data.{% enddocs %}

{% docs campaign_name %} The name of the campaign, if present in the source data.{% enddocs %}

{% docs clicks %} The count of clicks. The underlying platform metric varies: `taps` for Apple Search Ads and `swipes` for Snapchat Ads. {% enddocs %}

{% docs conversions %} The count of attributed conversion events. The underlying platform metric varies, for example `tap_installs` for Apple Search Ads, `total_conversions` for LinkedIn Ads, Pinterest, Snapchat Ads and Twitter Ads, `conversion` for TikTok Ads and `purchases_30_d` for Amazon Ads. Counts from different platforms therefore represent different events and are not directly comparable. {% enddocs %}

{% docs conversions_value %} The monetary value of attributed conversion events. This is null for Apple Search Ads in every report, and for Facebook Ads and TikTok Ads in the monthly country and region reports, as those platforms do not provide a conversion value for the relevant report. {% enddocs %}

{% docs date_day %} The day the metrics in this record were recorded. {% enddocs %}

{% docs impressions %} The count of impressions. {% enddocs %}

{% docs keyword_id %} The ID representing the keyword, if present in the source data. {% enddocs %}

{% docs keyword_match_type %} The match type the platform applied to the keyword. Values are passed through from the source platform and are not standardized across platforms. {% enddocs %}

{% docs keyword_text %} The keyword text.{% enddocs %}

{% docs platform %} The ad platform associated with this record.{% enddocs %}

{% docs search_match_type %} The match type the platform applied to the search query. Values are passed through from the source platform and are not standardized across platforms. {% enddocs %}

{% docs search_query %} The search query text. {% enddocs %}

{% docs spend %} The amount spent on the ads. Values are in each account's own currency and are not converted, so totals spanning accounts that bill in different currencies are not meaningful. {% enddocs %}

{% docs url_host %} The URL host of the ad. {% enddocs %}

{% docs url_path %} The URL path of the ad. {% enddocs %}

{% docs utm_campaign %} The utm_campaign parameter of the ad. {% enddocs %}

{% docs utm_content %} The utm_content parameter of the ad. {% enddocs %}

{% docs utm_medium %} The utm_medium parameter of the ad. {% enddocs %}

{% docs utm_source %} The utm_source parameter of the ad. {% enddocs %}

{% docs utm_term %} The utm_term parameter of the ad. {% enddocs %}

{% docs source_relation %} The source of the record if the unioning functionality is being used. If not this field will be empty. {% enddocs %}

{% docs date_month %} Month of the record, truncated to the first day of the month. {% enddocs %}

{% docs country %} Standardized ISO-3166 name of the country where the campaign was served. {% enddocs %}

{% docs country_code %} ISO-3166 two-letter code of the country where the campaign was served. {% enddocs %}

{% docs global_region %} Greater global region in which the country is located, using the UN M49 region names (for example `Northern Europe`, `Sub-Saharan Africa`, `Latin America and the Caribbean`). This is empty for countries that sit outside the scheme, such as Antarctica. {% enddocs %}

{% docs region %} Region the ad was served in. The formatting may vary across platforms. This may be a state, province, metropolitan area, etc. Snapchat Ads provides this as a two-letter abbreviation. {% enddocs %}

{% docs campaign_id_geo %} The ID representing the campaign, if present in the source data. Facebook Ads presents geographic data only at the account level and will have a null value for this field. {% enddocs %}

{% docs campaign_name_geo %} The name of the campaign, if present in the source data. Facebook Ads presents geographic data only at the account level and will have a value of `Account-level` for this field. {% enddocs %}
