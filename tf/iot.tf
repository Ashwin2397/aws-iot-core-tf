resource "aws_iot_thing" "iot_core" {
  name = "my-iot-core-thing"
}

resource "aws_iot_certificate" "iot_certificate" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "iot_attachment" {
  principal = aws_iot_certificate.iot_certificate.arn
  thing     = aws_iot_thing.iot_core.name
}

resource "aws_iot_topic_rule" "iot_rule" {
  name        = "iot_rule"
  sql         = "SELECT * FROM 'iot-core-topic'"
  sql_version = "2016-03-23"
  enabled     = true
  description = "Send data from the AWS IoT Core to S3"

  s3 {
    bucket_name = aws_s3_bucket.iot_core_bucket.bucket
    # TODO: This is not always a unique key, you need to format the date a bit differently for it to be unique
    key      = "iot-core-topic/${timestamp()}"
    role_arn = aws_iam_role.iot_role.arn
  }
}
