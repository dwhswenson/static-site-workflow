# Create the S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
  }
}

# Website configuration for the S3 bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Explicit public access block settings
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create IAM role for workflow
resource "aws_iam_role" "workflow_role" {
  name        = "${var.bucket_name}-workflow_role"
  description = "Role to allow GitHub workflows to access S3 bucket"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": { "Federated": var.oidc_provider_arn },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          "ForAnyValue:StringLike": {
            "token.actions.githubusercontent.com:sub": var.subject_filters
          }
        }
      }
    ]
  })

  tags = {
    Environment = "production"
    Name        = "GitHub Workflow Role"
  }
}

# create policy statements for the read-only buckets
data "aws_iam_policy_document" "role_policy_document" {
  dynamic "statement" {
    for_each = toset(var.read_only_buckets)
    content {
      actions = [
        "s3:GetObject",
        "s3:GetObjectTagging",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:GetObjectACL",
        "s3:ListBucket",
      ]
      resources = [
        "arn:aws:s3:::${statement.value}/*",
        "arn:aws:s3:::${statement.value}"
      ]
      effect    = "Allow"
  }
  }
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket.arn]
  }
}

# Attach inline policy to IAM role
resource "aws_iam_role_policy" "workflow_role_policy" {
  name = "s3-access-policy"
  role = aws_iam_role.workflow_role.id

  policy = data.aws_iam_policy_document.role_policy_document.json
}

# Define bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicWebAccess",
        "Effect": "Allow",
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.bucket.arn}/*",
        "Principal": "*"
      },
      {
        "Sid": "RoleListBucketAccess",
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": aws_s3_bucket.bucket.arn,
        "Principal": {
          "AWS": aws_iam_role.workflow_role.arn
        }
      },
      {
        "Sid": "RoleReadWriteAccess",
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectACL",
          "s3:PutObjectACL"
        ],
        "Resource": "${aws_s3_bucket.bucket.arn}/*",
        "Principal": {
          "AWS": aws_iam_role.workflow_role.arn
        }
      }
    ]
  })
}

resource "github_actions_secret" "aws_role" {
  repository = "${split("/", var.repository)[1]}"
  secret_name = "${var.gh_secret_prefix}_ROLE"
  plaintext_value = aws_iam_role.workflow_role.arn
}

resource "github_actions_secret" "bucket_name" {
  repository = "${split("/", var.repository)[1]}"
  secret_name = "${var.gh_secret_prefix}_BUCKET"
  plaintext_value = var.bucket_name
}
