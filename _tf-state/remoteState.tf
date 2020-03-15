provider "aws" {
    region = "us-east-2"
}

#Create S3 bucket to store state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-remotestate-jo-20200315"

  #Enable versioning so we can see full revision history of state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

/*
#Using an existing DynamoDB, 
but keeping this code here in case I need to recreate at some point.
DynamoDB for state locks
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-udemy-jo-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/