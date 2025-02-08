resource "aws_iam_user" "genesys_user" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy_attachment" "translate_full_access_attach" {
  user       = aws_iam_user.genesys_user.name
  policy_arn = "arn:aws:iam::aws:policy/TranslateFullAccess"
}

output "genesys_container_user_arn" {
  value = aws_iam_user.genesys_user.arn
}