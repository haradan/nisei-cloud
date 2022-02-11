# NISEI Cloud

Cloud hosting configuration shared between NISEI projects

## Terraform

[Terraform](https://www.terraform.io/intro) is used to manage cloud resources which NISEI projects will be deployed
into.

The preferred way to test and apply Terraform configuration is by pushing to GitHub and viewing the results in
[GitHub Actions](https://docs.github.com/en/actions). That way plans will be recorded and accessible for later
reference. This behaviour is configured in [GitHub Actions workflows](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

Some IDEs (eg. IntelliJ, RubyMine) have extra features for Terraform like navigating to the definition of a variable, resource or data source.
