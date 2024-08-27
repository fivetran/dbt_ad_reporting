## PR Overview
**This PR will address the following Issue/Feature:**

**This PR will result in the following new package version:**
<!--- Please add details around your decision for breaking vs non-breaking version upgrade. If this is a breaking change, were backwards-compatible options explored? -->

**Please provide the finalized CHANGELOG entry which details the relevant changes included in this PR:**
<!--- Copy/paste the CHANGELOG for this version below. -->

## PR Checklist
### Basic Validation
Please acknowledge that you have successfully performed the following commands locally:
- [ ] dbt run –full-refresh && dbt test
- [ ] dbt run (if incremental models are present) && dbt test

Before marking this PR as "ready for review" the following have been applied:
- [ ] The appropriate issue has been linked, tagged, and properly assigned
- [ ] All necessary documentation and version upgrades have been applied
- [ ] docs were regenerated (unless this PR does not include any code or yml updates)
- [ ] BuildKite integration tests are passing
- [ ] Detailed validation steps have been provided below

#### ❗ Special Updates for Ad Reporting ❗
To reduce integration testing time, not all models should be enabled in the `run_models.sh` vars. Update the variables after `dbt run` and `dbt test` to set:
- [ ] this PR's package to `true`
- [ ] Google Ads and Facebook Ads to `true` (if not already)
- [ ] All other packages to `false`

### Detailed Validation
Please share any and all of your validation steps:
<!--- Provide the steps you took to validate your changes below. -->

### If you had to summarize this PR in an emoji, which would it be?
<!--- For a complete list of markdown compatible emojis check our this git repo (https://gist.github.com/rxaviers/7360908)  --> 
:dancer:
