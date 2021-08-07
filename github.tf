provider "github" {
  owner = "bn-enginseer"
}

provider "github" {
  alias = "organization"
  owner = "bn-digital"
  token = var.github_org_token
}

resource "github_repository" "bn-enginseer" {
  name =                   "bn-enginseer"
  description =            "@bn-digital Software Engineer Avatar"
  homepage_url =           "https://bndigital.github.io"
  visibility =             "public"
  license_template =       "Unlicense"
  topics =                 ["terraform"]
  has_projects =           false
  has_issues =             false
  auto_init =              false
  delete_branch_on_merge = true
}

resource "github_branch_default" "latest" {
  branch =     "latest"
  repository = github_repository.bn-enginseer.id
}

// noinspection MissingProperty
resource "github_branch_protection" "admin-only-approval" {
  pattern =       github_repository.bn-enginseer.default_branch
  repository_id = github_repository.bn-enginseer.id
  required_pull_request_reviews {
    require_code_owner_reviews =      true
    required_approving_review_count = 1
  }
}

data "github_repository_pull_requests" "employee" {
  base_repository = github_repository.bn-enginseer.name
  base_ref =        github_repository.bn-enginseer.default_branch
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
