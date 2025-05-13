{% set include_list = [] %}
{% do include_list.append('facebook_ads') if var('facebook_ads__using_demographics_country', false) %}
{% do include_list.append('linkedin_ads') if var('linkedin_ads__using_geo', true) and var('linkedin_ads__using_monthly_ad_analytics_by_member_country', true) %}
{% do include_list.append('microsoft_ads') if var('microsoft_ads__using_geographic_daily_report', false) %}
{% do include_list.append('pinterest_ads') if var('pinterest__using_pin_promotion_targeting_report', true) and var('pinterest__using_targeting_geo', true) %}
{% do include_list.append('reddit_ads') if var('reddit_ads__using_campaign_country_report', true) %}
{% do include_list.append('snapchat_ads') if var('snapchat_ads__using_campaign_country_report', false) %}
{% do include_list.append('tiktok_ads') if var('tiktok_ads__using_campaign_country_report', true) %}
{% do include_list.append('twitter_ads') if var('twitter_ads__using_campaign_locations_report', false) %}

{% set enabled_packages = get_enabled_packages(include=include_list)%}
{{ config(enabled=is_enabled(enabled_packages)) }}

with base as (

    select *
    from {{ ref('int_ad_reporting__monthly_campaign_country_report') }}
),

country_mapping as (

    select *
    from {{ ref('int_ad_reporting__country_mapping') }}
),

{# May want to import this in via a macro but let's get it working first #}
{# {% set country_mapping = [
    {'country_name': 'Afghanistan', 'alternative_country_name': '', 'country_code': 'AF', 'global_region': 'Southern Asia'},
    {'country_name': 'Åland Islands', 'alternative_country_name': '', 'country_code': 'AX', 'global_region': 'Northern Europe'},
    {'country_name': 'Albania', 'alternative_country_name': '', 'country_code': 'AL', 'global_region': 'Southern Europe'},
    {'country_name': 'Algeria', 'alternative_country_name': '', 'country_code': 'DZ', 'global_region': 'Northern Africa'},
    {'country_name': 'American Samoa', 'alternative_country_name': '', 'country_code': 'AS', 'global_region': 'Polynesia'},
    {'country_name': 'Andorra', 'alternative_country_name': '', 'country_code': 'AD', 'global_region': 'Southern Europe'},
    {'country_name': 'Angola', 'alternative_country_name': '', 'country_code': 'AO', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Anguilla', 'alternative_country_name': '', 'country_code': 'AI', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Antarctica', 'alternative_country_name': '', 'country_code': 'AQ', 'global_region': ''},
    {'country_name': 'Antigua and Barbuda', 'alternative_country_name': '', 'country_code': 'AG', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Argentina', 'alternative_country_name': '', 'country_code': 'AR', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Armenia', 'alternative_country_name': '', 'country_code': 'AM', 'global_region': 'Western Asia'},
    {'country_name': 'Aruba', 'alternative_country_name': '', 'country_code': 'AW', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Australia', 'alternative_country_name': '', 'country_code': 'AU', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'Austria', 'alternative_country_name': '', 'country_code': 'AT', 'global_region': 'Western Europe'},
    {'country_name': 'Azerbaijan', 'alternative_country_name': '', 'country_code': 'AZ', 'global_region': 'Western Asia'},
    {'country_name': 'Bahamas', 'alternative_country_name': '', 'country_code': 'BS', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Bahrain', 'alternative_country_name': '', 'country_code': 'BH', 'global_region': 'Western Asia'},
    {'country_name': 'Bangladesh', 'alternative_country_name': '', 'country_code': 'BD', 'global_region': 'Southern Asia'},
    {'country_name': 'Barbados', 'alternative_country_name': '', 'country_code': 'BB', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Belarus', 'alternative_country_name': '', 'country_code': 'BY', 'global_region': 'Eastern Europe'},
    {'country_name': 'Belgium', 'alternative_country_name': '', 'country_code': 'BE', 'global_region': 'Western Europe'},
    {'country_name': 'Belize', 'alternative_country_name': '', 'country_code': 'BZ', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Benin', 'alternative_country_name': '', 'country_code': 'BJ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Bermuda', 'alternative_country_name': '', 'country_code': 'BM', 'global_region': 'Northern America'},
    {'country_name': 'Bhutan', 'alternative_country_name': '', 'country_code': 'BT', 'global_region': 'Southern Asia'},
    {'country_name': 'Bolivia (Plurinational State of)', 'alternative_country_name': 'Bolivia', 'country_code': 'BO', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Bonaire, Sint Eustatius and Saba', 'alternative_country_name': '', 'country_code': 'BQ', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Bosnia and Herzegovina', 'alternative_country_name': '', 'country_code': 'BA', 'global_region': 'Southern Europe'},
    {'country_name': 'Botswana', 'alternative_country_name': '', 'country_code': 'BW', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Bouvet Island', 'alternative_country_name': '', 'country_code': 'BV', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Brazil', 'alternative_country_name': '', 'country_code': 'BR', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'British Indian Ocean Territory', 'alternative_country_name': '', 'country_code': 'IO', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Brunei Darussalam', 'alternative_country_name': 'Brunei', 'country_code': 'BN', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Bulgaria', 'alternative_country_name': '', 'country_code': 'BG', 'global_region': 'Eastern Europe'},
    {'country_name': 'Burkina Faso', 'alternative_country_name': '', 'country_code': 'BF', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Burundi', 'alternative_country_name': '', 'country_code': 'BI', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Cabo Verde', 'alternative_country_name': 'Cape Verde', 'country_code': 'CV', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Cambodia', 'alternative_country_name': '', 'country_code': 'KH', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Cameroon', 'alternative_country_name': '', 'country_code': 'CM', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Canada', 'alternative_country_name': '', 'country_code': 'CA', 'global_region': 'Northern America'},
    {'country_name': 'Cayman Islands', 'alternative_country_name': '', 'country_code': 'KY', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Central African Republic', 'alternative_country_name': '', 'country_code': 'CF', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Chad', 'alternative_country_name': '', 'country_code': 'TD', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Chile', 'alternative_country_name': '', 'country_code': 'CL', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'China', 'alternative_country_name': '', 'country_code': 'CN', 'global_region': 'Eastern Asia'},
    {'country_name': 'Christmas Island', 'alternative_country_name': '', 'country_code': 'CX', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'Cocos (Keeling) Islands', 'alternative_country_name': '', 'country_code': 'CC', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'Colombia', 'alternative_country_name': '', 'country_code': 'CO', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Comoros', 'alternative_country_name': '', 'country_code': 'KM', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Congo', 'alternative_country_name': 'Republic of the Congo', 'country_code': 'CG', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Congo, Democratic Republic of the', 'alternative_country_name': 'Democratic Republic of the Congo', 'country_code': 'CD', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Cook Islands', 'alternative_country_name': '', 'country_code': 'CK', 'global_region': 'Polynesia'},
    {'country_name': 'Costa Rica', 'alternative_country_name': '', 'country_code': 'CR', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': "Côte d\'Ivoire", 'alternative_country_name': "Cote d\'Ivoire", 'country_code': 'CI', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Croatia', 'alternative_country_name': '', 'country_code': 'HR', 'global_region': 'Southern Europe'},
    {'country_name': 'Cuba', 'alternative_country_name': '', 'country_code': 'CU', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Curaçao', 'alternative_country_name': '', 'country_code': 'CW', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Cyprus', 'alternative_country_name': '', 'country_code': 'CY', 'global_region': 'Western Asia'},
    {'country_name': 'Czechia', 'alternative_country_name': 'Czech Republic', 'country_code': 'CZ', 'global_region': 'Eastern Europe'},
    {'country_name': 'Denmark', 'alternative_country_name': '', 'country_code': 'DK', 'global_region': 'Northern Europe'},
    {'country_name': 'Djibouti', 'alternative_country_name': '', 'country_code': 'DJ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Dominica', 'alternative_country_name': '', 'country_code': 'DM', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Dominican Republic', 'alternative_country_name': '', 'country_code': 'DO', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Ecuador', 'alternative_country_name': '', 'country_code': 'EC', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Egypt', 'alternative_country_name': '', 'country_code': 'EG', 'global_region': 'Northern Africa'},
    {'country_name': 'El Salvador', 'alternative_country_name': '', 'country_code': 'SV', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Equatorial Guinea', 'alternative_country_name': '', 'country_code': 'GQ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Eritrea', 'alternative_country_name': '', 'country_code': 'ER', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Estonia', 'alternative_country_name': '', 'country_code': 'EE', 'global_region': 'Northern Europe'},
    {'country_name': 'Eswatini', 'alternative_country_name': '', 'country_code': 'SZ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Ethiopia', 'alternative_country_name': '', 'country_code': 'ET', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Falkland Islands (Malvinas)', 'alternative_country_name': '', 'country_code': 'FK', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Faroe Islands', 'alternative_country_name': '', 'country_code': 'FO', 'global_region': 'Northern Europe'},
    {'country_name': 'Fiji', 'alternative_country_name': '', 'country_code': 'FJ', 'global_region': 'Melanesia'},
    {'country_name': 'Finland', 'alternative_country_name': '', 'country_code': 'FI', 'global_region': 'Northern Europe'},
    {'country_name': 'France', 'alternative_country_name': '', 'country_code': 'FR', 'global_region': 'Western Europe'},
    {'country_name': 'French Guiana', 'alternative_country_name': '', 'country_code': 'GF', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'French Polynesia', 'alternative_country_name': '', 'country_code': 'PF', 'global_region': 'Polynesia'},
    {'country_name': 'French Southern Territories', 'alternative_country_name': '', 'country_code': 'TF', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Gabon', 'alternative_country_name': '', 'country_code': 'GA', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Gambia', 'alternative_country_name': '', 'country_code': 'GM', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Georgia', 'alternative_country_name': '', 'country_code': 'GE', 'global_region': 'Western Asia'},
    {'country_name': 'Germany', 'alternative_country_name': '', 'country_code': 'DE', 'global_region': 'Western Europe'},
    {'country_name': 'Ghana', 'alternative_country_name': '', 'country_code': 'GH', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Gibraltar', 'alternative_country_name': '', 'country_code': 'GI', 'global_region': 'Southern Europe'},
    {'country_name': 'Greece', 'alternative_country_name': '', 'country_code': 'GR', 'global_region': 'Southern Europe'},
    {'country_name': 'Greenland', 'alternative_country_name': '', 'country_code': 'GL', 'global_region': 'Northern America'},
    {'country_name': 'Grenada', 'alternative_country_name': '', 'country_code': 'GD', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Guadeloupe', 'alternative_country_name': '', 'country_code': 'GP', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Guam', 'alternative_country_name': '', 'country_code': 'GU', 'global_region': 'Micronesia'},
    {'country_name': 'Guatemala', 'alternative_country_name': '', 'country_code': 'GT', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Guernsey', 'alternative_country_name': '', 'country_code': 'GG', 'global_region': 'Northern Europe'},
    {'country_name': 'Guinea', 'alternative_country_name': '', 'country_code': 'GN', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Guinea-Bissau', 'alternative_country_name': '', 'country_code': 'GW', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Guyana', 'alternative_country_name': '', 'country_code': 'GY', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Haiti', 'alternative_country_name': '', 'country_code': 'HT', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Heard Island and McDonald Islands', 'alternative_country_name': '', 'country_code': 'HM', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'Holy See', 'alternative_country_name': '', 'country_code': 'VA', 'global_region': 'Southern Europe'},
    {'country_name': 'Honduras', 'alternative_country_name': '', 'country_code': 'HN', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Hong Kong', 'alternative_country_name': 'Hong Kong SAR China', 'country_code': 'HK', 'global_region': 'Eastern Asia'},
    {'country_name': 'Hungary', 'alternative_country_name': '', 'country_code': 'HU', 'global_region': 'Eastern Europe'},
    {'country_name': 'Iceland', 'alternative_country_name': '', 'country_code': 'IS', 'global_region': 'Northern Europe'},
    {'country_name': 'India', 'alternative_country_name': '', 'country_code': 'IN', 'global_region': 'Southern Asia'},
    {'country_name': 'Indonesia', 'alternative_country_name': '', 'country_code': 'ID', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Iran (Islamic Republic of)', 'alternative_country_name': 'Iran', 'country_code': 'IR', 'global_region': 'Southern Asia'},
    {'country_name': 'Iraq', 'alternative_country_name': '', 'country_code': 'IQ', 'global_region': 'Western Asia'},
    {'country_name': 'Ireland', 'alternative_country_name': '', 'country_code': 'IE', 'global_region': 'Northern Europe'},
    {'country_name': 'Isle of Man', 'alternative_country_name': '', 'country_code': 'IM', 'global_region': 'Northern Europe'},
    {'country_name': 'Israel', 'alternative_country_name': '', 'country_code': 'IL', 'global_region': 'Western Asia'},
    {'country_name': 'Italy', 'alternative_country_name': '', 'country_code': 'IT', 'global_region': 'Southern Europe'},
    {'country_name': 'Jamaica', 'alternative_country_name': '', 'country_code': 'JM', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Japan', 'alternative_country_name': '', 'country_code': 'JP', 'global_region': 'Eastern Asia'},
    {'country_name': 'Jersey', 'alternative_country_name': '', 'country_code': 'JE', 'global_region': 'Northern Europe'},
    {'country_name': 'Jordan', 'alternative_country_name': '', 'country_code': 'JO', 'global_region': 'Western Asia'},
    {'country_name': 'Kazakhstan', 'alternative_country_name': '', 'country_code': 'KZ', 'global_region': 'Central Asia'},
    {'country_name': 'Kenya', 'alternative_country_name': '', 'country_code': 'KE', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Kiribati', 'alternative_country_name': '', 'country_code': 'KI', 'global_region': 'Micronesia'},
    {'country_name': "Korea (Democratic People''s Republic of)", 'alternative_country_name': '', 'country_code': 'KP', 'global_region': 'Eastern Asia'},
    {'country_name': 'Korea, Republic of', 'alternative_country_name': 'South Korea', 'country_code': 'KR', 'global_region': 'Eastern Asia'},
    {'country_name': 'Kuwait', 'alternative_country_name': '', 'country_code': 'KW', 'global_region': 'Western Asia'},
    {'country_name': 'Kyrgyzstan', 'alternative_country_name': '', 'country_code': 'KG', 'global_region': 'Central Asia'},
    {'country_name': "Lao People''s Democratic Republic", 'alternative_country_name': 'Laos', 'country_code': 'LA', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Latvia', 'alternative_country_name': '', 'country_code': 'LV', 'global_region': 'Northern Europe'},
    {'country_name': 'Lebanon', 'alternative_country_name': '', 'country_code': 'LB', 'global_region': 'Western Asia'},
    {'country_name': 'Lesotho', 'alternative_country_name': '', 'country_code': 'LS', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Liberia', 'alternative_country_name': '', 'country_code': 'LR', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Libya', 'alternative_country_name': '', 'country_code': 'LY', 'global_region': 'Northern Africa'},
    {'country_name': 'Liechtenstein', 'alternative_country_name': '', 'country_code': 'LI', 'global_region': 'Western Europe'},
    {'country_name': 'Lithuania', 'alternative_country_name': '', 'country_code': 'LT', 'global_region': 'Northern Europe'},
    {'country_name': 'Luxembourg', 'alternative_country_name': '', 'country_code': 'LU', 'global_region': 'Western Europe'},
    {'country_name': 'Macao', 'alternative_country_name': 'Macau', 'country_code': 'MO', 'global_region': 'Eastern Asia'},
    {'country_name': 'Madagascar', 'alternative_country_name': '', 'country_code': 'MG', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Malawi', 'alternative_country_name': '', 'country_code': 'MW', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Malaysia', 'alternative_country_name': '', 'country_code': 'MY', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Maldives', 'alternative_country_name': '', 'country_code': 'MV', 'global_region': 'Southern Asia'},
    {'country_name': 'Mali', 'alternative_country_name': '', 'country_code': 'ML', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Malta', 'alternative_country_name': '', 'country_code': 'MT', 'global_region': 'Southern Europe'},
    {'country_name': 'Marshall Islands', 'alternative_country_name': '', 'country_code': 'MH', 'global_region': 'Micronesia'},
    {'country_name': 'Martinique', 'alternative_country_name': '', 'country_code': 'MQ', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Mauritania', 'alternative_country_name': '', 'country_code': 'MR', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Mauritius', 'alternative_country_name': '', 'country_code': 'MU', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Mayotte', 'alternative_country_name': '', 'country_code': 'YT', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Mexico', 'alternative_country_name': '', 'country_code': 'MX', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Micronesia (Federated States of)', 'alternative_country_name': 'Micronesia', 'country_code': 'FM', 'global_region': 'Micronesia'},
    {'country_name': 'Moldova, Republic of', 'alternative_country_name': 'Moldova', 'country_code': 'MD', 'global_region': 'Eastern Europe'},
    {'country_name': 'Monaco', 'alternative_country_name': '', 'country_code': 'MC', 'global_region': 'Western Europe'},
    {'country_name': 'Mongolia', 'alternative_country_name': '', 'country_code': 'MN', 'global_region': 'Eastern Asia'},
    {'country_name': 'Montenegro', 'alternative_country_name': '', 'country_code': 'ME', 'global_region': 'Southern Europe'},
    {'country_name': 'Montserrat', 'alternative_country_name': '', 'country_code': 'MS', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Morocco', 'alternative_country_name': '', 'country_code': 'MA', 'global_region': 'Northern Africa'},
    {'country_name': 'Mozambique', 'alternative_country_name': '', 'country_code': 'MZ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Myanmar', 'alternative_country_name': '', 'country_code': 'MM', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Namibia', 'alternative_country_name': '', 'country_code': '', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Nauru', 'alternative_country_name': '', 'country_code': 'NR', 'global_region': 'Micronesia'},
    {'country_name': 'Nepal', 'alternative_country_name': '', 'country_code': 'NP', 'global_region': 'Southern Asia'},
    {'country_name': 'Netherlands (Kingdom of the)', 'alternative_country_name': 'Netherlands', 'country_code': 'NL', 'global_region': 'Western Europe'},
    {'country_name': 'New Caledonia', 'alternative_country_name': '', 'country_code': 'NC', 'global_region': 'Melanesia'},
    {'country_name': 'New Zealand', 'alternative_country_name': '', 'country_code': 'NZ', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'Nicaragua', 'alternative_country_name': '', 'country_code': 'NI', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Niger', 'alternative_country_name': '', 'country_code': 'NE', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Nigeria', 'alternative_country_name': '', 'country_code': 'NG', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Niue', 'alternative_country_name': '', 'country_code': 'NU', 'global_region': 'Polynesia'},
    {'country_name': 'Norfolk Island', 'alternative_country_name': '', 'country_code': 'NF', 'global_region': 'Australia and New Zealand'},
    {'country_name': 'North Macedonia', 'alternative_country_name': '', 'country_code': 'MK', 'global_region': 'Southern Europe'},
    {'country_name': 'Northern Mariana Islands', 'alternative_country_name': '', 'country_code': 'MP', 'global_region': 'Micronesia'},
    {'country_name': 'Norway', 'alternative_country_name': '', 'country_code': 'NO', 'global_region': 'Northern Europe'},
    {'country_name': 'Oman', 'alternative_country_name': '', 'country_code': 'OM', 'global_region': 'Western Asia'},
    {'country_name': 'Pakistan', 'alternative_country_name': '', 'country_code': 'PK', 'global_region': 'Southern Asia'},
    {'country_name': 'Palau', 'alternative_country_name': '', 'country_code': 'PW', 'global_region': 'Micronesia'},
    {'country_name': 'Palestine, State of', 'alternative_country_name': '', 'country_code': 'PS', 'global_region': 'Western Asia'},
    {'country_name': 'Panama', 'alternative_country_name': '', 'country_code': 'PA', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Papua New Guinea', 'alternative_country_name': '', 'country_code': 'PG', 'global_region': 'Melanesia'},
    {'country_name': 'Paraguay', 'alternative_country_name': '', 'country_code': 'PY', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Peru', 'alternative_country_name': '', 'country_code': 'PE', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Philippines', 'alternative_country_name': '', 'country_code': 'PH', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Pitcairn', 'alternative_country_name': '', 'country_code': 'PN', 'global_region': 'Polynesia'},
    {'country_name': 'Poland', 'alternative_country_name': '', 'country_code': 'PL', 'global_region': 'Eastern Europe'},
    {'country_name': 'Portugal', 'alternative_country_name': '', 'country_code': 'PT', 'global_region': 'Southern Europe'},
    {'country_name': 'Puerto Rico', 'alternative_country_name': '', 'country_code': 'PR', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Qatar', 'alternative_country_name': '', 'country_code': 'QA', 'global_region': 'Western Asia'},
    {'country_name': 'Réunion', 'alternative_country_name': '', 'country_code': 'RE', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Romania', 'alternative_country_name': '', 'country_code': 'RO', 'global_region': 'Eastern Europe'},
    {'country_name': 'Russian Federation', 'alternative_country_name': 'Russia', 'country_code': 'RU', 'global_region': 'Eastern Europe'},
    {'country_name': 'Rwanda', 'alternative_country_name': '', 'country_code': 'RW', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Saint Barthélemy', 'alternative_country_name': 'St. Barthélemy', 'country_code': 'BL', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Saint Helena, Ascension and Tristan da Cunha', 'alternative_country_name': 'St. Helena, Ascension and Tristan da Cunha', 'country_code': 'SH', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Saint Kitts and Nevis', 'alternative_country_name': 'St. Kitts and Nevis', 'country_code': 'KN', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Saint Lucia', 'alternative_country_name': 'St. Lucia', 'country_code': 'LC', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Saint Martin (French part)', 'alternative_country_name': 'St. Martin (French part)', 'country_code': 'MF', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Saint Pierre and Miquelon', 'alternative_country_name': 'St. Pierre and Miquelon', 'country_code': 'PM', 'global_region': 'Northern America'},
    {'country_name': 'Saint Vincent and the Grenadines', 'alternative_country_name': 'St. Vincent and the Grenadines', 'country_code': 'VC', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Samoa', 'alternative_country_name': '', 'country_code': 'WS', 'global_region': 'Polynesia'},
    {'country_name': 'San Marino', 'alternative_country_name': '', 'country_code': 'SM', 'global_region': 'Southern Europe'},
    {'country_name': 'Sao Tome and Principe', 'alternative_country_name': 'São Tomé and Principe', 'country_code': 'ST', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Saudi Arabia', 'alternative_country_name': '', 'country_code': 'SA', 'global_region': 'Western Asia'},
    {'country_name': 'Senegal', 'alternative_country_name': '', 'country_code': 'SN', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Serbia', 'alternative_country_name': '', 'country_code': 'RS', 'global_region': 'Southern Europe'},
    {'country_name': 'Seychelles', 'alternative_country_name': '', 'country_code': 'SC', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Sierra Leone', 'alternative_country_name': '', 'country_code': 'SL', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Singapore', 'alternative_country_name': '', 'country_code': 'SG', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Sint Maarten (Dutch part)', 'alternative_country_name': '', 'country_code': 'SX', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Slovakia', 'alternative_country_name': '', 'country_code': 'SK', 'global_region': 'Eastern Europe'},
    {'country_name': 'Slovenia', 'alternative_country_name': '', 'country_code': 'SI', 'global_region': 'Southern Europe'},
    {'country_name': 'Solomon Islands', 'alternative_country_name': '', 'country_code': 'SB', 'global_region': 'Melanesia'},
    {'country_name': 'Somalia', 'alternative_country_name': '', 'country_code': 'SO', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'South Africa', 'alternative_country_name': '', 'country_code': 'ZA', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'South Georgia and the South Sandwich Islands', 'alternative_country_name': '', 'country_code': 'GS', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'South Sudan', 'alternative_country_name': '', 'country_code': 'SS', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Spain', 'alternative_country_name': '', 'country_code': 'ES', 'global_region': 'Southern Europe'},
    {'country_name': 'Sri Lanka', 'alternative_country_name': '', 'country_code': 'LK', 'global_region': 'Southern Asia'},
    {'country_name': 'Sudan', 'alternative_country_name': '', 'country_code': 'SD', 'global_region': 'Northern Africa'},
    {'country_name': 'Suriname', 'alternative_country_name': '', 'country_code': 'SR', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Svalbard and Jan Mayen', 'alternative_country_name': '', 'country_code': 'SJ', 'global_region': 'Northern Europe'},
    {'country_name': 'Sweden', 'alternative_country_name': '', 'country_code': 'SE', 'global_region': 'Northern Europe'},
    {'country_name': 'Switzerland', 'alternative_country_name': '', 'country_code': 'CH', 'global_region': 'Western Europe'},
    {'country_name': 'Syrian Arab Republic', 'alternative_country_name': '', 'country_code': 'SY', 'global_region': 'Western Asia'},
    {'country_name': 'Taiwan, Province of China', 'alternative_country_name': 'Taiwan', 'country_code': 'TW', 'global_region': 'Eastern Asia'},
    {'country_name': 'Tajikistan', 'alternative_country_name': '', 'country_code': 'TJ', 'global_region': 'Central Asia'},
    {'country_name': 'Tanzania, United Republic of', 'alternative_country_name': 'Tanzania', 'country_code': 'TZ', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Thailand', 'alternative_country_name': '', 'country_code': 'TH', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Timor-Leste', 'alternative_country_name': '', 'country_code': 'TL', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Togo', 'alternative_country_name': '', 'country_code': 'TG', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Tokelau', 'alternative_country_name': '', 'country_code': 'TK', 'global_region': 'Polynesia'},
    {'country_name': 'Tonga', 'alternative_country_name': '', 'country_code': 'TO', 'global_region': 'Polynesia'},
    {'country_name': 'Trinidad and Tobago', 'alternative_country_name': '', 'country_code': 'TT', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Tunisia', 'alternative_country_name': '', 'country_code': 'TN', 'global_region': 'Northern Africa'},
    {'country_name': 'Türkiye', 'alternative_country_name': 'Turkey', 'country_code': 'TR', 'global_region': 'Western Asia'},
    {'country_name': 'Turkmenistan', 'alternative_country_name': '', 'country_code': 'TM', 'global_region': 'Central Asia'},
    {'country_name': 'Turks and Caicos Islands', 'alternative_country_name': '', 'country_code': 'TC', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Tuvalu', 'alternative_country_name': '', 'country_code': 'TV', 'global_region': 'Polynesia'},
    {'country_name': 'Uganda', 'alternative_country_name': '', 'country_code': 'UG', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Ukraine', 'alternative_country_name': '', 'country_code': 'UA', 'global_region': 'Eastern Europe'},
    {'country_name': 'United Arab Emirates', 'alternative_country_name': '', 'country_code': 'AE', 'global_region': 'Western Asia'},
    {'country_name': 'United Kingdom of Great Britain and Northern Ireland', 'alternative_country_name': 'United Kingdom', 'country_code': 'GB', 'global_region': 'Northern Europe'},
    {'country_name': 'United States of America', 'alternative_country_name': 'United States', 'country_code': 'US', 'global_region': 'Northern America'},
    {'country_name': 'United States Minor Outlying Islands', 'alternative_country_name': '', 'country_code': 'UM', 'global_region': 'Micronesia'},
    {'country_name': 'Uruguay', 'alternative_country_name': '', 'country_code': 'UY', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Uzbekistan', 'alternative_country_name': '', 'country_code': 'UZ', 'global_region': 'Central Asia'},
    {'country_name': 'Vanuatu', 'alternative_country_name': '', 'country_code': 'VU', 'global_region': 'Melanesia'},
    {'country_name': 'Venezuela (Bolivarian Republic of)', 'alternative_country_name': 'Venezuela', 'country_code': 'VE', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Viet Nam', 'alternative_country_name': 'Vietnam', 'country_code': 'VN', 'global_region': 'South-eastern Asia'},
    {'country_name': 'Virgin Islands (British)', 'alternative_country_name': 'British Virgin Islands', 'country_code': 'VG', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Virgin Islands (U.S.)', 'alternative_country_name': '', 'country_code': 'VI', 'global_region': 'Latin America and the Caribbean'},
    {'country_name': 'Wallis and Futuna', 'alternative_country_name': '', 'country_code': 'WF', 'global_region': 'Polynesia'},
    {'country_name': 'Western Sahara', 'alternative_country_name': '', 'country_code': 'EH', 'global_region': 'Northern Africa'},
    {'country_name': 'Yemen', 'alternative_country_name': '', 'country_code': 'YE', 'global_region': 'Western Asia'},
    {'country_name': 'Zambia', 'alternative_country_name': '', 'country_code': 'ZM', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Zimbabwe', 'alternative_country_name': '', 'country_code': 'ZW', 'global_region': 'Sub-Saharan Africa'},
    {'country_name': 'Kosovo', 'alternative_country_name': '', 'country_code': 'XK', 'global_region': 'Southern Europe'},
] %}

{% if target.type == 'postgres' %}
{% do country_mapping.append({'country_name': "Côte d''Ivoire", 'alternative_country_name': "Cote d''Ivoire", 'country_code': 'CI', 'global_region': 'Sub-Saharan Africa'}) %}
{% else %}
{% do country_mapping.append({'country_name': "Côte d\'Ivoire", 'alternative_country_name': "Cote d\'Ivoire", 'country_code': 'CI', 'global_region': 'Sub-Saharan Africa'}) %}
{% endif %}

standardize_country_names as (

    select 
        *,
        case
        {% for country in country_mapping %}
            {%- if country.alternative_country_name != '' -%}
            when country = '{{ country.alternative_country_name | replace("'", "\\'") if target.type != "postgres" else country.alternative_country_name | replace("'", "''") }}' then '{{ country.country_name | replace("'", "\\'") if target.type != "postgres" else country.country_name | replace("'", "''") }}'
            {% endif -%}
        {% endfor %} 
        else country end as standardized_alt_country_name

    from base 

),

map_countries_and_codes as (

    select 
        *,

        case 
        {% for country in country_mapping %}
            when standardized_alt_country_name is null and country_code = '{{ country.country_code }}' then '{{ country.country_name | replace("'", "\\'") if target.type != "postgres" else country.country_name | replace("'", "''") }}'
        {% endfor %}
        else standardized_alt_country_name end as standardized_country,

        case 
        {% for country in country_mapping %}
            when country_code is null and standardized_alt_country_name = '{{ country.country_name | replace("'", "\\'") if target.type != "postgres" else country.country_name | replace("'", "''") }}' then '{{ country.country_code }}'
        {% endfor %}
        else country_code end as standardized_country_code

    from standardize_country_names 

), #}

standardize_country_names as (

    select 
        base.*,
        coalesce(country_mapping.country_name, base.country) as standardized_alt_country_name

    from base 
    left join country_mapping
        on base.country = country_mapping.alternative_country_name
),

map_countries_and_codes as (

    select 
        standardize_country_names.*,
        coalesce(standardize_country_names.standardized_alt_country_name, country_mapping.country_name) as standardized_country,
        coalesce(standardize_country_names.country_code, country_mapping.country_code) as standardized_country_code

    from standardize_country_names 
    left join country_mapping
        on standardize_country_names.standardized_alt_country_name = country_mapping.country_name
        or standardize_country_names.country_code = country_mapping.country_code
),

aggregated as (
    
    select
        source_relation,
        {{ dbt.date_trunc("month", "date_day") }} as date_month,
        platform,
        account_id,
        account_name,
        campaign_id,
        campaign_name,
        standardized_country as country,
        standardized_country_code as country_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value

        {{ ad_reporting_persist_pass_through_columns(pass_through_variable='ad_reporting__country_passthrough_metrics', transform = 'sum', alias_fields=['conversions', 'conversions_value']) }}

    from map_countries_and_codes
    {{ dbt_utils.group_by(9) }}
)

select *
from aggregated