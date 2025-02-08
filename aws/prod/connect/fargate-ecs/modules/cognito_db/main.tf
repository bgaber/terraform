data "aws_partition" "current" {}

data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
}

resource "aws_dynamodb_table" "connectproddbstackconnectprod74_cf2916" {
  name             = var.table_name
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  replica {
    region_name = var.dr_region
  }

  global_secondary_index {
    name               = "pk-index"
    hash_key           = "pk"
    range_key          = "sk"
    projection_type    = "KEYS_ONLY"
  }

  point_in_time_recovery {
    enabled = true
  }
  table_class = "STANDARD"
}

resource "aws_lambda_layer_version" "connectproduserpoolstacklambdafunctionlayer69_efc6_a4" {
  s3_bucket           = var.s3_bucket
  s3_key              = var.lambda_layer_pkg
  compatible_runtimes = ["nodejs18.x"]
  description         = "node fetch"
  layer_name          = "connect-prod-pool-node-fetch"
}

resource "aws_iam_role" "connectproduserpoolstackconnectprodpretokengeneratorrole_e252_a9_fd" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  description = "Custom role permitting resources in lambda"
  managed_policy_arns = [
    aws_iam_policy.userstackconnectprodpolicy_d516_cf36.arn
  ]
  name = var.lambda_function_role
}

resource "aws_lambda_function" "pre_token_generator" {
  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  role          = aws_iam_role.connectproduserpoolstackconnectprodpretokengeneratorrole_e252_a9_fd.arn
  handler       = "pre-token-generator.handler"

  s3_bucket = var.s3_bucket
  s3_key    = var.ptg_lambda_deployment_pkg

  runtime   = "nodejs18.x"

  environment {
    variables = {
      MULESOFT_HOST = var.mulesoft_host
      MULESOFT_KEY  = var.mulesoft_key
      TABLE_NAME    = var.table_name
    }
  }

  layers = [
    aws_lambda_layer_version.connectproduserpoolstacklambdafunctionlayer69_efc6_a4.arn
  ]
  memory_size = 128
  timeout = 3
}

resource "aws_lambda_permission" "connectproduserpoolstackuserpool_pre_token_generation_cognito38_f97_dbd" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pre_token_generator.arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.arn
}

resource "aws_cognito_user_pool" "connectproduserpoolstackuserpool2798_f515" {
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_email"
      priority = 2
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
  auto_verified_attributes = ["email"]

  # Conflicts with verification_message_template configuration block
  # email_verification_message = "The verification code to your new account is {####}"
  # email_verification_subject = "Verify your new account"
  # sms_verification_message = "The verification code to your new account is {####}"
  lambda_config {
    pre_token_generation = aws_lambda_function.pre_token_generator.arn
  }
  username_attributes = ["email"]
  username_configuration {
    case_sensitive = false
  }
  name = "connect-prod-pool"
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "The verification code to your new account is {####}"
    email_subject        = "Verify your new account"
    sms_message          = "The verification code to your new account is {####}"
  }
}

resource "aws_cognito_identity_provider" "connect_idps" {
  for_each      = var.idp_saml_names
  user_pool_id  = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.id
  provider_name = each.key
  provider_type = "SAML"

  provider_details = {
    # compose path to SAML file
    #MetadataURL = join("", ["https://", var.s3_bucket, ".s3.amazonaws.com/", each.value, ".xml"])
    #MetadataURL = each.value == "usg" ? "https://lbfrprodam.diam.compucom.com/openam/saml2/jsp/exportmetadata.jsp?entityid=https://lbfrprodam.diam.compucom.com:443/openam/USG&realm=/USG" : join("", ["https://", var.s3_bucket, ".s3.amazonaws.com/", each.value, ".xml"])
    MetadataURL = each.value
  }

  attribute_mapping = {
    #email        = "emailAddress"
    email        = each.key == "iiroc.ca" ? "xfrupn" : "emailAddress"
    family_name  = "lastName"
    given_name   = "firstName"
    name         = "firstName"
    phone_number = "phoneNumber"
  }

# https://github.com/hashicorp/terraform-provider-aws/issues/4831
  lifecycle {
    ignore_changes = [
      provider_details["SLORedirectBindingURI"],
      provider_details["SSORedirectBindingURI"],
      provider_details["ActiveEncryptionCertificate"],
    ]
  }
}

resource "aws_cognito_user_pool_domain" "connectproduserpoolstackuserpool_cognito_domain_fbd7_bf8_f" {
  domain       = "connect-prod-domain"
  user_pool_id = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.id
}

resource "aws_cognito_user_pool_client" "connectproduserpoolstackuserpoolclient_f4_e238_d6" {
  user_pool_id = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.id
  access_token_validity = 5
  allowed_oauth_flows = [
    "code"
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
    "profile",
    "phone",
    "email",
    "openid"
  ]
  auth_session_validity = 5
  callback_urls = [
    "https://connect.compucom.com/api/auth/callback/cognito"
  ]
  name = "connect-prod-pool-client"
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  generate_secret = true
  id_token_validity = 5
  read_attributes = [
    "email",
    "family_name",
    "given_name",
    "phone_number",
    "name"
  ]

  # supported_identity_providers is list of provider names for the identity providers that are supported on this client.
  # therefore, type of supported_identity_providers is list 
  supported_identity_providers = keys(var.idp_saml_names)
  token_validity_units {
    access_token = "minutes"
    id_token     = "minutes"
  }
  write_attributes = [
    "email",
    "family_name",
    "given_name",
    "phone_number",
    "name"
  ]
}

resource "aws_iam_role_policy" "connectproduserpoolstackuserpoolclient_describe_cognito_user_pool_client_custom_resource_policy_b13_ef0_c6" {
  policy = jsonencode({
    Statement = [
      {
        Action   = "cognito-idp:DescribeUserPoolClient"
        Effect   = "Allow"
        Resource = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.arn
      }
    ]
    Version = "2012-10-17"
  })
  name = "connectproduserpoolstackuserpoolclientDescribeCognitoUserPoolClientCustomResourcePolicyB13EF0C6"
  role = aws_iam_role.aws679f53fac002430cb0da5b7982bd2287_service_role_c1_ea0_ff2.id
}

resource "aws_iam_role" "aws679f53fac002430cb0da5b7982bd2287_service_role_c1_ea0_ff2" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  managed_policy_arns = [
    join("", ["arn:", data.aws_partition.current.partition, ":iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"])
  ]
}

resource "aws_lambda_function" "aws679f53fac002430cb0da5b7982bd22872_d164_c4_c" {
  description   = "For Custom::DescribeCognitoUserPoolClient"
  function_name = "Unknown-Custom-Lambda-Function"
  role          = aws_iam_role.aws679f53fac002430cb0da5b7982bd2287_service_role_c1_ea0_ff2.arn
  handler       = "index.handler"

  runtime = "nodejs16.x"

  s3_bucket = var.s3_bucket
  s3_key    = var.custom_lambda_deployment_pkg

  timeout = 120
}

resource "aws_iam_policy" "userstackconnectprodpolicy_d516_cf36" {
  name = "connect-prod-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/amplify/*:log-stream:*",
          "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/lambda/*:log-stream:*"
        ]
      },
      {
        Action = "logs:CreateLogGroup"
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/amplify/*",
          "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/lambda/*"
        ]
      },
      {
        Action = "logs:DescribeLogGroups"
        Effect = "Allow"
        Resource = "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:*"
      },
      {
        Action = [
          "cognito-identity:*",
          "cognito-idp:*"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "dynamodb:*"
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.connectproddbstackconnectprod74_cf2916.arn,
          "arn:aws:dynamodb:${var.dr_region}:${local.account_id}:table/connect-table"
        ]  
      },
      {
        Action = "s3:*"
        Effect = "Allow"
        Resource = "arn:aws:s3:::connect-uat-logos-bucket/*"
      }
    ]
    Version = "2012-10-17"
  })  
}

resource "aws_iam_role" "userstackconnectprodrole_a605_cc3_e" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  description = "Custom role permitting resources creation from Amplify"
  managed_policy_arns = [
    aws_iam_policy.userstackconnectprodpolicy_d516_cf36.arn
  ]
  name = "connect-prod-role"
}

resource "aws_iam_user" "userstackconnectproduser_ed98_c79_f" {
  name = "connect-prod-user"
}

resource "aws_iam_user_policy_attachment" "connect-prod-attach" {
  user       = aws_iam_user.userstackconnectproduser_ed98_c79_f.name
  policy_arn = aws_iam_policy.userstackconnectprodpolicy_d516_cf36.arn
}

# resource "aws_iam_access_key" "userstack_cfn_access_key_d9_b01_e0_c" {
#   user = aws_iam_user.userstackconnectproduser_ed98_c79_f.name
# }


output "s3_bucket_url" {
  value = "https://s3.us-east-1.amazonaws.com/connect-uat-logos-bucket"
}

output "connect_table" {
  value = aws_dynamodb_table.connectproddbstackconnectprod74_cf2916.arn
}

output "db_arn" {
  value = aws_dynamodb_table.connectproddbstackconnectprod74_cf2916.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.connectproduserpoolstackuserpool2798_f515.id
}

output "cognito_client_secret" {
  value = aws_cognito_user_pool_client.connectproduserpoolstackuserpoolclient_f4_e238_d6.client_secret
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.connectproduserpoolstackuserpoolclient_f4_e238_d6.id
}

# output "access_key" {
#   value = aws_iam_access_key.userstack_cfn_access_key_d9_b01_e0_c.create_date
# }

# output "access_secret" {
#   value = aws_iam_access_key.userstack_cfn_access_key_d9_b01_e0_c.secret
# }
