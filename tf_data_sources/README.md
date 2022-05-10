Terraform - Data Sources (1)


### Data Sources Examples

- VPC,  subnets
- AMIs
- Data about user / role used by TF to manage AWS resources


The main goal of this small project is to create an instance in the 2nd subnet of the default VPC of the current region, without having to know the VPC or subnet Ids

Additionally, we also create a security group that references the default vpc, again, without knowing the default VPC

We also explore  the  "aws_caller_identity" that allows us to gather info about the IAM principal used by TF to configure AWS (identity, account, etc.) 

We also use local variables and/or to help us visualize what we created

- For example, if we are not getting the AMI we expect (e.g. linux kernel 4.x instead of 5.x) we can output (or put into a local variable) all the info from data.aws_ami.amazon_linux2_kernel_5 and this may help us troubleshoot the filter.

### Additional exercises
- Create a VPC by hand simulating a pre-existing VPC (perhaps created by another terraform module).  Add data sources to refer to this VPC's and its subnets.  Add a test2 instance deployed in the 2nd
- Find the availability zones in the current region and add outputs to display them.  Do you need to know the region? 

### References
VPC data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
Subnet data source: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
