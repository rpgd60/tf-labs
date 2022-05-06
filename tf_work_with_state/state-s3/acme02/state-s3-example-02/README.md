Testing S3 State

Convention used in these examples / course
- State bucket specific to project specified in var.project (e.g. "acme02)).
- Each app within the project (e.g. example-01 and example-02) use app-specific keys within the same bucket
- Lock table is also unique per project.  Terraform will add an app-specific item when locking the state

For app  "example-01"
    bucket         = "acme02-terraform-state-dev"           
    dynamodb_table = "acme02-terraform-state-locks-dev"
    key            = "acme02/example-01/terraform.tfstate"  ## Note key is application specific

For app  "example-02"
    bucket         = "acme02-terraform-state-dev"           
    dynamodb_table = "acme02-terraform-state-locks-dev"
    key            = "acme02/example-02/terraform.tfstate"  ## Note key is application specific


Exploring the Dynamodb table with the CLI (scan)

Scan of items in state table when there are no locks
Yields one entry per "state-key" in the S3 bucket

```
aws dynamodb scan --table-name acme02-terraform-state-locks-dev 
ConsumedCapacity: null
Count: 2
Items:
- Digest:
    S: b474940dc4296bb2db6d0484faede85a
  LockID:
    S: acme02-terraform-state-dev/acme02/example-02/terraform.tfstate-md5
- Digest:
    S: 71bfe965dbf64a678d430d2e520f2c9f
  LockID:
    S: acme02-terraform-state-dev/acme02/example-01/terraform.tfstate-md5
ScannedCount: 2
```

Scan of table when a lock is acquired.  In this case run `terraform destroy` in the example-01 directory and scan table while terraform waits for user confirmation ('yes')

Note there is a new item in table associated with the path to the state of this application:
```
aws dynamodb scan --table-name acme02-terraform-state-locks-dev 
ConsumedCapacity: null
Count: 3
Items:
- Digest:
    S: b474940dc4296bb2db6d0484faede85a
  LockID:
    S: acme02-terraform-state-dev/acme02/example-02/terraform.tfstate-md5
- Digest:
    S: 71bfe965dbf64a678d430d2e520f2c9f
  LockID:
    S: acme02-terraform-state-dev/acme02/example-01/terraform.tfstate-md5
- Info:
    S: '{"ID":"b51a95d4-a170-b341-6e8f-26b2b3112213","Operation":"OperationTypeApply","Info":"","Who":"rafa@rp3","Version":"1.1.7","Created":"2022-05-04T10:21:49.787882302Z","Path":"acme02-terraform-state-dev/acme02/example-01/terraform.tfstate"}'
  LockID:
    S: acme02-terraform-state-dev/acme02/example-01/terraform.tfstate
ScannedCount: 3

```