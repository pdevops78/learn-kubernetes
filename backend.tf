terraform {
  backend "s3" {
      bucket = "bucketinfo23"
      key    = "test/dev/file"
      region = "us-east-1"
  }
}