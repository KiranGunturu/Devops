variable "s3_folder_path" {
    description = "path to the s3 fodler"
    type = string
  
}

provider "aws" {
    region = "us-east-1"
  
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "engineering-sales"
  tags = {
    Name        = "data-engineering-sales"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_object" "s3_folder" {
    key    = "orders/"
    bucket = aws_s3_bucket.s3_bucket.id

}

resource "aws_glue_catalog_database" "sales_db" {
  name = "sales_db"
}

resource "aws_iam_role" "s3-glue-athena" {
  name = "GlueAndS3Role"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
  role       = aws_iam_role.s3-glue-athena.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Allows access to the specific S3 bucket."

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.s3_bucket.arn}",
        "${aws_s3_bucket.s3_bucket.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3-glue-athena.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_glue_crawler" "sales_crawler_test" {
  database_name = aws_glue_catalog_database.sales_db.name
  name          = "sales_crawler"
  role          = aws_iam_role.s3-glue-athena.arn

  s3_target {
    path = "s3://${aws_s3_bucket.s3_bucket.id}/${var.s3_folder_path}/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
  }

  configuration = <<EOF
{
  "Version":1.0,
  "Grouping": {
    "TableGroupingPolicy": "CombineCompatibleSchemas"
  }
}
EOF
}