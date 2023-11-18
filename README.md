# Overview

The goals of this project is as follows:
- Understand the overhead involved with streaming multimedia (MM) data from IoT sensors
- Understand how AWS IoT Core handles MM streaming
- Gain a deeper understanding of Terraform

# Deploy

```bash
terraform apply --auto-approve
```

# Test

## Setup

Reference [deploy](#deploy)

## Publish messsage

```bash
aws iot-data publish \
  --topic "iot-core-topic" \
  --cli-binary-format raw-in-base64-out \
  --payload fileb://test/fixtures/example.png \
  --region "us-east-1"
```

## List Object Keys

```bash
aws s3api list-objects --bucket iot-core-test-bucket-ashwin-selva | jq -r '.Contents[].Key'
```
Identify the latest object based on the key name.

## Retrieve message (object) from bucket

```bash
aws s3api get-object --bucket iot-core-test-bucket-ashwin-selva --key <key-from-previous-step> example.png
```

## Teardown

### Empty Bucket

```bash
aws s3api delete-object --bucket iot-core-test-bucket-ashwin-selva --key <key-to-delete>
```

### Destroy resources

```bash
terraform destroy --auto-approve
```

For good measure, ensure that `resources` in `terraform.tfstate` is an empty list.
