resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

data "aws_iam_policy_document" "bitbucket_policy_doc" {
  statement {
    sid       = "LambdaAccess"
    effect    = "Allow"
    actions   = ["lambda:UpdateFunctionCode"]
    resources = [
                "arn:aws:lambda:us-east-1:122639376858:function:*-router",
                "arn:aws:lambda:us-east-1:122639376858:function:kendra_Search",
                "arn:aws:lambda:us-east-1:122639376858:function:process-twilio-message"
    ]
  }
}

resource "aws_iam_user_policy" "bitbucket_policy" {
  name   = "AI_SelfHelp_Lambda_Write_Policy"
  user   = aws_iam_user.bitbucket_user.name
  policy = data.aws_iam_policy_document.bitbucket_policy_doc.json
}

output "aws_iam_user_arn" {
  value = aws_iam_user.bitbucket_user.arn
}