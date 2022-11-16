terraform {
    backend "s3" {
        bucket = "s3_statefile"
        key = "test/statefile"
        region = "us-east-2"
    }
}
resource "s3" "remote_state" {
    bucket = "remote_state_s3"
    
    versioning {
        enabled = true
    }
    tags {
        Name = "remote_state_s3"
    }
  
}
