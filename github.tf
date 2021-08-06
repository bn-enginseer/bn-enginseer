provider "github" {
  alias = "employee"
  owner = "bn-enginseer"
}

provider "github" {
  alias = "organization"
  owner = "bn-enginseer"
}

data "github_repository_pull_requests" "employee" {
  provider =        github.employee
  base_repository = "bn-enginseer"
  base_ref =        "latest"
  sort_by =         "created"
  sort_direction =  "asc"
  state =           "closed"
}

locals {
  // noinspection HILUnresolvedReference
  employees = data.github_repository_pull_requests.employee.results
}

resource "github_membership" "organization-members" {
  provider = github.organization
  count =    length(local.employees)
  // noinspection HILUnresolvedReference
  username = local.employees[count.index].head_owner
  role =     "member"
  lifecycle {
    ignore_changes = [role]
  }
}
