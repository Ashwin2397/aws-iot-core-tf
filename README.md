# Overview

The goals of this project is as follows:
- Understand the overhead involved with streaming multimedia (MM) data from IoT sensors
- Understand how AWS IoT Core handles MM streaming
- Gain a deeper understanding of Terraform

# Setup

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Sign up for AWS, navigate to _Security Credentials_ and create an access key
- Create a `.env` and add the following
  ```bash
  AWS_ACCESS_KEY_ID=<access-key-id>
  AWS_SECRET_ACCESS_KEY=<secret-access-key>
  ```
- Replace `tf/s3.tf#3` with your own bucket name
- Initialize Terraform
  ```bash
  terraform init
  ```

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
bucket=<your-bucket-name>
aws s3api list-objects --bucket $bucket | jq -r '.Contents[].Key'
```
Identify the latest object based on the key name.

## Retrieve message (object) from bucket

```bash
aws s3api get-object --bucket $bucket --key <key-from-previous-step> example.png
```

## Teardown

### Empty Bucket

```bash
aws s3api delete-object --bucket $bucket --key <key-to-delete>
```

### Destroy resources

```bash
terraform destroy --auto-approve
```

For good measure, ensure that `resources` in `terraform.tfstate` is an empty list.
