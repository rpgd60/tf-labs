Testing S3 State

Here the S3-related configuration in the provider block is almost  and we provide the common parameters (once) from a common file when running `terraform init` in this directory. 

Tip: save the actual init command in the README.md or more generally parametrize it in a higher level orchestration tool

Note: backend.hcl is common and kept in a common parent directory

```
$ ls 
dependencies.tf  main.tf  outputs.tf  providers.tf  README.md  terraform.tfvars  variables.tf

$ ls ..
backend.hcl  state-bucket  state-s3-example-01  state-s3-example-02  state-s3-example-03

$ cat ../backend.hcl 
# backend.hcl
bucket         = "acme02-terraform-state-dev"           
dynamodb_table = "acme02-terraform-state-locks-dev"
region         = "eu-west-1"
encrypt        = true
```
Running terraform init
```
$ terraform init --backend=true --backend-config=../backend.hcl

```

Verifying we now have 3 keys under the state bucket:
```
aws s3 ls s3://acme02-terraform-state-dev --recursive
2022-05-04 12:36:11      13520 acme02/example-01/terraform.tfstate
2022-05-04 12:36:07      13604 acme02/example-02/terraform.tfstate
2022-05-04 13:39:58      13534 acme02/example-03/terraform.tfstate
```
