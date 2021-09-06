############
# IAM users
############
provider "aws" {
  region = "ca-central-1"
}
module "iam_user1" {
  source = "../../modules/iam-user"

  name = "jbesona"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
}

module "iam_user2" {
  source = "../../modules/iam-user"

  name = "enketi"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
}

module "iam_user3" {
  source = "../../modules/iam-user"
  name = "slegah"
  create_iam_user_login_profile = false
  create_iam_access_key  =  false
}

module "iam_user4" {
  source = "../../modules/iam-user"
  name = "bdoh"
  create_iam_user_login_profile = false
  create_iam_access_key  =  false
}

module "iam_user5" {
  source = "../../modules/iam-user"
  name = "bdanny"
  create_iam_user_login_profile = false
  create_iam_access_key  =  false
}

#############################################################################################
# IAM group where user1 and user2 are allowed to assume admin role in production AWS account
#############################################################################################
module "iam_group_complete" {
  source = "../../modules/iam-group-with-assumable-roles-policy"

  name = "production-admins"

  assumable_roles = ["arn:aws:iam::111111111111:role/admin"]

  group_users = [
    module.iam_user1.iam_user_name,
    module.iam_user2.iam_user_name,
    module.iam_user3.iam_user_name,
    module.iam_user4.iam_user_name,
    module.iam_user5.iam_user_name,

  ]
}

####################################################
# Extending policies of IAM group production-admins
####################################################
module "iam_group_complete_with_custom_policy" {
  source = "../../modules/iam-group-with-policies"

  name = module.iam_group_complete.group_name

  create_group = false

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
}
