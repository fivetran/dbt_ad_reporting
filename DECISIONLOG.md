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