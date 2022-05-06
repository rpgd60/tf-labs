Terraform - S3 Backend

## Intro

This terraform code creates a bucket  to store Terraform state and a dynamodb table to serve as lock.

- bucket <project>-terraform-state-<environment> e.g. acme02-terraform-state-dev
- dynamodb database <project>-terraform-state-locks-<environment> e.g. acme02-terraform-state-locks-dev


Convention used in these examples / course
- State bucket specific to project specified in var.project (e.g. "acme02)).
    - ${var.project}-terraform-state-${var.environment}   
- Lock table is also unique per project.  Terraform will add an app-specific item when locking the state
    - ${var.project}-terraform-state-locks-${var.environment}   
- Each app within the project (e.g. example-01 and example-02) use app-specific keys within the same bucket
    - ${var.project}/

Example:

For app  "example-01"
    bucket         = "acme02-terraform-state-dev"           
    dynamodb_table = "acme02-terraform-state-locks-dev"
    key            = "acme02/example-01/terraform.tfstate"  ## Note key is application specific

For app  "example-02"
    bucket         = "acme02-terraform-state-dev"           
    dynamodb_table = "acme02-terraform-state-locks-dev"
    key            = "acme02/example-02/terraform.tfstate"  ## Note key is application specific


## Assorted Notes
### 1. Why iam_principal_info in outputs?

We explicitly list in the outputs the IAM principal identity to remind us to tighten further the security of the state bucket, perhaps with a bucket policy

```
iam_principal_info = {
  "account_id" = "012345678912"
  "arn" = "arn:aws:iam::012345678912:user/tfadmin1"
  "id" = "012345678912"
  "user_id" = "AIDATSOPQRSTYOGP7LXWL"
}
```

### 2. s3 bucket lifecycle - what happens when we change

We disabled this part of the code inside the bucket resource while tuning the config and enabled it once satisifed all was as we wanted.

```
    lifecycle {
      prevent_destroy = true
    }
```
