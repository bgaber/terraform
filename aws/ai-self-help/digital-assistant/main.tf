resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy_attachment" "lambda_full_access_attach" {
  user       = aws_iam_user.bitbucket_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}