resource "aws_iam_role" "iot_role" {
  name = "iot-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "iot.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "iot_role_publish_policy" {
  name = "iot-publish-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iot:Publish",
            "Resource": "*"
        }
    ]
}
EOF

}

resource "aws_iam_policy" "iot_s3_policy" {
  name        = "iot-s3-policy"
  description = "iot role s3 put policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "s3:PutObject",
          "Resource": "*"
      }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "iot_role_policy_attch" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.iot_s3_policy.arn
}
