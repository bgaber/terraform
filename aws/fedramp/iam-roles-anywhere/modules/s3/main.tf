resource "aws_rolesanywhere_trust_anchor" "crowdstrike_falcon_ng_siem_data_connector" {
  name = var.trust_anchor_name
  enabled = true
  source {
    source_data {
      x509_certificate_data = file("/home/briang/crowdstrike/root-ca/root-ca.crt")
    }
    source_type = "CERTIFICATE_BUNDLE"
  }
}

resource "aws_iam_role" "crowdstrike_falcon_ng_siem_data_connector" {
  name = var.iam_role_name
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
        Service = "rolesanywhere.amazonaws.com",
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_rolesanywhere_profile" "crowdstrike_falcon_ng_siem_data_connector" {
  name      = var.roles_anywhere_profile_name
  enabled   = true
  role_arns = [aws_iam_role.crowdstrike_falcon_ng_siem_data_connector.arn]
}

output "aws_rolesanywhere_trust_anchor_arn" {
  value = aws_rolesanywhere_trust_anchor.crowdstrike_falcon_ng_siem_data_connector.arn
}

output "aws_rolesanywhere_trust_anchor_id" {
  value = aws_rolesanywhere_trust_anchor.crowdstrike_falcon_ng_siem_data_connector.id
}

output "aws_rolesanywhere_profile_arn" {
  value = aws_rolesanywhere_profile.crowdstrike_falcon_ng_siem_data_connector.arn
}

output "aws_rolesanywhere_profile_id" {
  value = aws_rolesanywhere_profile.crowdstrike_falcon_ng_siem_data_connector.id
}