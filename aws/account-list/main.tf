data "external" "aws_sso_accounts" {
  program = ["bash", "-c", <<EOT
    aws sso list-accounts --access-token ${var.sso_access_token} --region ${var.region} | jq -c '{accounts: [.accountList[].accountId] | join(",")}'
  EOT
  ]
}

output "aws_accounts" {
  value = split(",", data.external.aws_sso_accounts.result["accounts"])
}