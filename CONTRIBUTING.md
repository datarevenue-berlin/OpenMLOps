# Contributing to OpenMLOPs

Thank you for contributing to OpenMLOPs 🎉 Please follow the guidelines to contribute to the project.

## Getting started

We recommend that you follow this [tutorial](https://github.com/datarevenue-berlin/OpenMLOps/blob/master/tutorials/set-up-open-source-production-mlops-architecture-aws.md) to start your OpenMLOPs cluster on AWS. 

## Bug report

Please follow the guidelines for bug reports. Good bug reports are extremely 
helpful for the mainterners - thank you!

1. Check if the issue has already been reported.
2. Try to reproduce the issue using the `master` branch.
3. If the problem persists, please submit a bug report with as many details as possible. Include information about your Terraform version. Please provide steps to reproduce the issue and the outcome that you  are expecting. 

## Submit your code

In order to submit code, please:
- Fork the repository
- Create a new branch on your fork (preferably with this format `[GITHUB_USERNAME]/[BRANCH_NAME]`)
- Add a changelog to CHANGELOG.md See the guidelines below.
- Open a pull request. Please add PR descriptions to help the reviewers.
- A core maintainer will review your PR and provide feedback. Once approved, your PR will be merged.

## Add a changelog

It's important to add a changelog. You can add your changelog to one of the following headers:
- `Features` (for new features)
- `Enhancements` (for improvements to existing features)
- `Bug fixes`
- `Deprecation`
- `Breaking` (for breaking changes)

Then, please add bullet points under the heading, describing the change.

Here's an example of a PR that adds a new feature

```
### Features

- Support running Prefect tasks using existing Dask clusters
```
