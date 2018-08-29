resource "aws_iam_role" "lambda_role" {
  name = "lambda_iam_${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy_policy_${var.name}"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": ${var.policy_statements}
}
EOF
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "${var.zip_path}"
  function_name    = "${var.name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "${var.name}"
  source_code_hash = "${base64sha256(file("${var.zip_path}"))}"
  runtime          = "go1.x"
}
