# static-site-workflow

Features:

* Staging site: Automatically deploy a staging site on every PR.
* Entire workflow based on GitHub Actions.
* Optionally deploy production to AWS S3.

## Usage

### Prerequisites

1. GitHub repository for your static site.
2. AWS account.
3. Install OpenTofu on your local machine. (Terraform should also work, but
   these instructions will be based on OpenTofu.)
4. (Recommended) Create a bucket in AWS S3 to store your Terraform state.


### Infrastructure

The infrastructure is managed by infrastructure as code (IaC) using OpenTofu.
This will include both AWS resources and GitHub variables and secrets.

If your DNS is not on AWS, you will need to take steps to 

#### Full AWS Solution (DNS, production site, staging site)

Use the module at `dwhswenson/static-site-workflow//tf` to create the necessary
resources. This has all you need.

#### AWS for storage (production and staging), DNS elsewhere

1. Create a certificate in AWS Certificate Manager for your domain. Use DNS
   verification, which will require you to create CNAME records in your DNS.

2. Use the module at `dwhswenson/static-site-workflow//tf`, with parameters ???.

3. Manually point the domain to the CloudFront distribution.

#### Only staging on AWS

1. Use the module at `dwhswenson/static-site-workflow//tf/modules/static-site` to
   create the necessary resources.

### GitHub Actions

#### Staging site

See the workflows in `workflows/staging/` for examples. This consists of 4
workflow files. Three run sequentially every time you build a PR:

...

The fourth cleans up the staging site when a PR is closed.

#### Production site

See the workflows in `workflows/prod/` for examples.
