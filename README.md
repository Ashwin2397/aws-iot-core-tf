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
- `make setup`

# Deploy

```bash
terraform apply --auto-approve
```

# Test

## 1. Setup

Reference [deploy](#deploy)

## 2. Run subscriber script

```bash
ruby client.rb subscribe <subscriber-count> <log-id>
```

**Example:**

```bash
ruby client.rb subscribe 100 100_big_2
```

## 3. Publish messsage

### Run publish script

```bash
ruby client.rb publish <file-path> <log-id>
```

**Example:**

```bash
ruby client.rb publish fixtures/big_2.jpg 100_big_2
```

**Note:** 
- Reference the files in `/fixtures`
- Ensure that the `log_id` used here is the same as the `log_id` used in the step 2

## 4. Run statistics script

```bash
 ruby statistics_calculator.rb <log-id>
```

**Example:**

```bash
ruby statistics_calculator.rb 100_big_2
```

**Note:**
- Ensure that the `log_id` used here is the same as the `log_id` used in the step 2

## 5. Teardown

### Empty Bucket

```bash
aws s3api delete-object --bucket $bucket --key <key-to-delete>
```

### Destroy resources

```bash
terraform destroy --auto-approve
```

For good measure, ensure that `resources` in `terraform.tfstate` is an empty list.

# Others: Interfacing w/ AWS CLI

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

## Publish message

```bash
aws iot-data publish \
  --topic "iot-core-topic" \
  --cli-binary-format raw-in-base64-out \
  --payload fileb://example.png \
  --region "us-east-1"
```
