variable "users" {
  type = map(object(
    {
    #   name = string
      dept = string
      is_admin = bool
    }
  ))
  default = {
    rafa = {
        dept = "IT"
        is_admin = true
        employee_id = 33333
    }, 
    paco = {
        dept = "Planning"
        is_admin = false
    }, 
    "jose andres" = {
        dept = "Accounting"
        is_admin = false
    }
  }
}



locals {
  admin_users = {
    for name, user in var.users : name => user
    if user.is_admin
  }
  regular_users = {
    for name, user in var.users : name => user
    if !user.is_admin
  }
}
