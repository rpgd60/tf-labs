 This configuration explores using AWS IAM roles in the context of AWS Organizations

 The cast of characters is:

 AWS Organizations with
 - A management account (we also call it parent account for clarity)
    - we will NOT be configuring stuff in this account with Terraform
 - A managed or member account (we also call it child account)
    - This is the account were we will be doing things with Terraform
    - We provide the number here with variable "child_account_number"

- A IAM user in the management account,  associated with a profile and credentials in my local machine.
    - we provide this with variable "parent_account_profile"

- A role defined in the child account that has associated policies that allow anyone assuming the role to manage the child account
    - we provide this with variable "child_account_role".  This variable has a default value "OrganizationAccountAccessRole" which is the one created by default by AWS Organizations when creating a child/managed account.

- The sequence of events is that Terraform accesses the AWS Organization parent account with the "parent_account_profile" and immediately assumes the role "child_account_role" in the child/managed account ("child_account_number").   
    - To assume the role inside the provider we have to build an arn (Amazon Resource Name) such as: "arn:aws:iam::12345689012:role/OrganizationAccountAccessRole"