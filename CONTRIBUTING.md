# Contributing to `dbt_ad_reporting`

`dbt_ad_reporting` is open source software. It is what it is today because community members have opened issues, provided feedback, and contributed to the knowledge loop. Whether you are a seasoned open source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project. This repo is public and anything you contribute to the package is viewable by the entire community.

All PRs must be associated with a [Github issue](https://github.com/fivetran/dbt_ad_reporting/issues). We cannot guarantee that your proposal will be accepted. Please look through the open issues first to see if something similar already exists, and comment on it with an outline for your planned implementation before opening a pull request. If you cannot find an existing issue addressing your desired change, open a new one describing your desired outcome and outlining your planned change. 

As a community contributor, we ask that you only make changes to files in the models folder,  macros folder, main dbt_project.yml, and individual seed csv files as necessary. 

### AI Usage

We welcome and encourage AI-assisted contributions, but will prioritize those that address a true issue or clear improvement to the package. AI makes it much easier and faster to scan the codebase and open PRs than ever before. Agents are incentivized to find bugs and things that could potentially become issues, but may not be causing real friction right now. Our top priority is developing and maintaining a high-quality set of dbt packages for all of our users. To that end, we must prioritize overall stability and planned improvements over a long tail of niche potential features.

### Notes

- **CLA:** Please note that anyone contributing code to `dbt_ad_reporting` must sign the Contributor License Agreement which will be available in the PR as a comment. If you are unable to sign the CLA, the maintainers will be unable to merge any of your Pull Requests. We still welcome you to participate in discussions, open issues, and comment on existing ones.

- **Branches:** All pull requests from community contributors should target the `main` branch (default).

- **Integration Tests Seed Data:** Seed data is intended to test model compilation for CI purposes only and is not necessarily reflective of real-world data. Do not use model outputs from seed data alone as an indication of potential issues in the code.

## Getting the code

### Installing git

You will need `git` in order to download and modify the `dbt_ad_reporting` source code. On macOS, the best way to download git is to just install [Xcode](https://developer.apple.com/support/xcode/).

### External contributors

External contributors can contribute to `dbt_ad_reporting` by forking this repository. For a detailed overview on forking, check out the [GitHub docs on forking](https://help.github.com/en/articles/fork-a-repo). In short, you will need to:

1. Fork the `dbt_ad_reporting` repository
2. Clone your fork locally
3. Check out a new branch for your proposed changes
4. Push changes to your fork
5. Open a pull request against `fivetran/dbt_ad_reporting` from your forked repository

## Testing

PRs must include robust testing. Comprehensive testing within pull requests is crucial for the stability of the package ecosystem. By prioritizing robust testing, we ensure the reliability of our codebase, minimize unforeseen issues, and safeguard against potential regressions. We cannot merge changes that risk the backward incompatibility of existing documented behaviors.

Before opening your PR, make sure you're comfortable sharing its contents and supporting information publicly. In the PR, include test results showing that your change works as intended and does not cause unintended downstream effects. Use the seed data in integration_tests/seeds to validate your assertions.

Your changes should:
- Preserve existing functionality.
- Handle all known edge cases.
- Continue to work as expected over time.

## Submitting a Pull Request

We receive more PRs than we can thoroughly review, test, and merge. Our packages are maintained by a small team of engineers with finite capacity. Once a maintainer is able to review your PR, they may suggest code revisions or have additional questions for you. Once approved, they will create a release branch (not main) to merge your PR and make the final revisions, including version bump and Changelog entry. Once all tests have passed and approvals provided, the release branch will be merged into the code base and you will be listed as a contributor. Thank you for your commitment to contributing to the integrity of our codebase and the experience of everyone using this dbt package! Happy developing!